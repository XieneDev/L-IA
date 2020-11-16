extends KinematicBody2D

const SHOOT_SPD := 300

const AIR_DECC := 300
const DECC := 900

var out := false
var velocity := Vector2.ZERO


onready var shoot_sfx := $ShootSFX
onready var pick_sfx := $PickSFX


func _ready() -> void:
	visible = false
	set_physics_process(false)


func shoot(player: KinematicBody2D) -> void:
	visible = true
	position = player.position
	velocity = player.direction.normalized() * SHOOT_SPD
	player.velocity = -player.direction.normalized() * SHOOT_SPD
	out = true
	set_physics_process(true)
	shoot_sfx.play()


func grab(play_sfx: bool) -> void:
	position = Vector2.ZERO
	out = false
	visible = false
	set_physics_process(false)
	if play_sfx:
		pick_sfx.play()


func _physics_process(delta: float) -> void:
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, DECC*delta)
	else:
		velocity.x = move_toward(velocity.x, 0, AIR_DECC*delta)
	velocity.y += Globals.GRAV*delta
	
	velocity = move_and_slide(velocity, Vector2.UP)

