extends StaticBody2D

var color : int
var original_frame : int
var sub_coord : Vector2

var inverted : bool

onready var sprite = $Sprite
onready var collision = $CollisionShape2D


func _ready() -> void:
	color = sub_coord.x/2
	sprite.frame = sub_coord.x
	inverted = sprite.frame % 2 == 1
	original_frame = sprite.frame
	collision.disabled = inverted


func changed_state(i, value) -> void:
	if i == color:
		sprite.frame = original_frame + (1-2*int(inverted) if value else 0)
		collision.disabled = value != inverted
