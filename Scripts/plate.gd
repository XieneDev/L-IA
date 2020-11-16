extends StaticBody2D

var color : int
var original_frame : int
var active := false
var sub_coord : Vector2

onready var sprite = $Sprite


func _ready() -> void:
	color = sub_coord.x
	sprite.frame = sub_coord.x
	original_frame = sprite.frame


func _on_Area2D_body_entered(body: Node2D) -> void:
	if body == Globals.core:
		active = true
		sprite.frame = original_frame+2
		Globals.set_state(color, true, self)


func core_exited() -> void:
	active = false
	sprite.frame = original_frame
	Globals.set_state(color, false, self)


func _on_Area2D_body_exited(body: Node2D) -> void:
	if body == Globals.core:
		core_exited()
