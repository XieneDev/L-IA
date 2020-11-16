extends Node2D

var sub_coord : Vector2

onready var beat_level_sfx := $BeatLevelSFX


func _ready() -> void:
	pass


func _on_Area2D_body_entered(body: Node2D) -> void:
	if body is Player and not Globals.core.out:
		body.position = position + Vector2(0, 4)
		body.beat_level()
		beat_level_sfx.play()
