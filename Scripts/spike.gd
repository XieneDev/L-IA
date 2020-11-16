extends Node2D

var sub_coord : Vector2


func _on_Area2D_body_entered(body: Node2D) -> void:
	if body is Player:
		RespawnManager.respawn()
