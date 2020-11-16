extends KinematicBody2D
class_name Player

const SPD := 150
const ACC := 900
const DECC := 1000

const MAX_FALL_SPD := 1200
const FALL_MULTIPLIER_EXTRA := 0.5

const JUMP_SPEED := 250
const JUMP_THRESHOLD := 100

const LOW_JUMP_SPEED := 175
const LOW_JUMP_THRESHOLD := 65

const GRACE_TIME := 0.1
var grace_timer : float
var started_jump := false

const PRE_GRACE_TIME := 0.1
var pre_grace_timer : float = 0

const SHOOT_TIME := 0.15
var shoot_timer : float

var colliding_core := false
var interactable : Node2D = null
var facing_right := true
var direction := Vector2.RIGHT
var velocity := Vector2.ZERO
var initial_pos : Vector2
var beaten_level := false
var can_move := false

onready var sprite := $Sprite
onready var area := $Area2D
onready var animation_player := $AnimationPlayer
onready var animation_tree := $AnimationTree
onready var animation_state : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
onready var tween = $Tween

onready var jump_sfx := $JumpSFX
onready var lever_sfx := $LeverSFX
onready var die_sfx := $DieSFX

var core_preload := preload("res://Objects/Core.tscn")


func _ready() -> void:
	save_state()
	
	Globals.core = core_preload.instance()
	get_parent().call_deferred("add_child", Globals.core)
	
	Globals.can_pause = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	appear(0.25)
	
	# Register the player as grounded, prevents an animation bug on the first frame after spawning in
	velocity = move_and_slide(Vector2.ZERO, Vector2.UP)


func appear(delay: float) -> void:
	can_move = false
	animation_state.travel("Idle")
	sprite.modulate = Color(1, 1, 1, 0)
	tween.interpolate_property(sprite, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_SINE, Tween.EASE_IN, delay)
	tween.start()


func _physics_process(delta: float) -> void:
	if not can_move:
		return
	
	move(delta)
	set_direction()
	grabbing()
	
	if Input.is_action_just_pressed("ui_interact"):
		if interactable and is_on_floor():
			interacting()
		else:
			shooting()
	
	if shoot_timer >= 0:
		shoot_timer -= delta
	
	if Input.is_action_just_pressed("ui_reset"):
		RespawnManager.respawn()


func move(delta: float) -> void:
	var desired_x := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	desired_x *= SPD
	
	if desired_x != 0:
		velocity.x = move_toward(velocity.x, desired_x, ACC*delta)
		facing_right = sign(desired_x) > 0
		sprite.flip_h = not facing_right
		if is_on_floor():
			animation_state.travel("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, DECC*delta)
		if is_on_floor():
			animation_state.travel("Idle")
	
	
	pre_grace_timer -= delta
	if Input.is_action_just_pressed("ui_jump"):
		pre_grace_timer = PRE_GRACE_TIME
	
	if pre_grace_timer > 0 and grace_timer > 0:
		velocity.y = -(LOW_JUMP_SPEED if Globals.core.out else JUMP_SPEED)
		started_jump = true
		jump_sfx.play()
		pre_grace_timer = 0
	if not Input.is_action_pressed("ui_jump") and started_jump:
		var threshold = -(LOW_JUMP_THRESHOLD if Globals.core.out else JUMP_THRESHOLD)
		if velocity.y < threshold and velocity.y < 0:
			velocity.y = threshold
	
	velocity.y += Globals.GRAV * delta
	if velocity.y > 0:
		velocity.y += FALL_MULTIPLIER_EXTRA * Globals.GRAV * delta
	velocity.y = min(velocity.y, MAX_FALL_SPD)
	
	grace_timer -= delta
	if is_on_floor():
		grace_timer = GRACE_TIME
	else:
		animation_state.travel("Jump")
	
	velocity = move_and_slide(velocity, Vector2.UP)


func interacting() -> void:
	interactable.interact(self)
	lever_sfx.play()


func shooting() -> void:
	if not Globals.core.out:
		shoot()


func shoot() -> void:
	shoot_timer = SHOOT_TIME
	$Sprite/NoCore.visible = true
	started_jump = false
	Globals.core.shoot(self)


func grabbing() -> void:
	if colliding_core and shoot_timer < 0:
		grab(true)


func grab(play_sfx: bool) -> void:
	colliding_core = false
	Globals.core.grab(play_sfx)
	$Sprite/NoCore.visible = false


func set_direction() -> void:
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if direction.y != 0:
		direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	else:
		direction.x = 1 if facing_right else -1


func save_state() -> void:
	initial_pos = position


func respawn() -> void:
	position = initial_pos
	velocity = Vector2.ZERO
	facing_right = true
	sprite.flip_h = false
	grab(false)
	die_sfx.play()
	appear(0)


func beat_level() -> void:
	set_physics_process(false)
	animation_tree.active = false
	sprite.frame = 0
	tween.interpolate_property(sprite, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_SINE, Tween.EASE_IN, 0.5)
	tween.start()
	beaten_level = true
	Globals.can_pause = false


func _on_Area2D_body_entered(body: Node2D) -> void:
	if body == Globals.core:
		colliding_core = true


func _on_Area2D_body_exited(body: Node2D) -> void:
	if body == Globals.core:
		colliding_core = false


func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	if beaten_level:
		SceneManager.goto_next_level()
	else:
		can_move = true
