tool
extends Node2D

export(Vector2) var travel_vector = Vector2.ZERO setget set_travel_vector

onready var next_pos : Vector2 = position + travel_vector
var sub_coord : Vector2

onready var sprite = $Sprite
onready var tween = $Tween


func _ready() -> void:
	if not Engine.editor_hint and travel_vector != Vector2.ZERO:
		RythmManager.connect("beat", self, "beat")


func _process(delta: float) -> void:
	if not Engine.editor_hint:
		sprite.rotation += delta*8


func beat() -> void:
	tween.interpolate_property(self, "position", position, next_pos, RythmManager.TRANSITION_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.0)
	next_pos = position
	tween.start()


func _on_Area2D_body_entered(body: Node2D) -> void:
	if body is Player and not Engine.editor_hint:
		RespawnManager.respawn()


func set_travel_vector(new_val: Vector2) -> void:
	travel_vector = new_val
	update()


func _draw() -> void:
	if not Engine.editor_hint:
		return
	
	draw_line(Vector2.ZERO, travel_vector, Color(1, 1, 1, 1), 2.0)
