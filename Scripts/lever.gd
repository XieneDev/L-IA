extends Node2D

var color : int
var original_frame : int
var active := false
var sub_coord : Vector2

onready var sprite := $Sprite


func _ready() -> void:
	color = sub_coord.x/2
	sprite.frame = sub_coord.x
	original_frame = sprite.frame


func interact(_player: Player) -> void:
	active = not active
	sprite.frame = (original_frame+4) if active else original_frame
	Globals.set_state(color, active, self)


func reset_state() -> void:
	active = false
	sprite.frame = original_frame


func _on_Area2D_body_entered(body: Node2D) -> void:
	if body is Player:
		body.interactable = self


func _on_Area2D_body_exited(body: Node2D) -> void:
	if body is Player:
		body.interactable = null
