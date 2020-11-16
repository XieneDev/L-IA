extends Node

func save_state() -> void:
	get_tree().call_group("Respawn", "save_state")

func respawn() -> void:
	Globals.reset_state()
	get_tree().call_group("Respawn", "respawn")
