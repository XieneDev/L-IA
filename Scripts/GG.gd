extends Control


var can_restart := false


func _ready() -> void:
	OptionsMenu.get_node("Control").disconnect("turn_off", PauseMenu.get_node("Control"), "options_turn_off")


func _input(event: InputEvent) -> void:
	if (event is InputEventKey and event.pressed) or (event is InputEventJoypadButton and event.pressed):
		if can_restart:
			PauseMenu.get_node("Control/SelectSFX").play()
			get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_Timer_timeout() -> void:
	can_restart = true
