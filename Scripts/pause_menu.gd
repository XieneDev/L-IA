extends Control


onready var resume_button := $VBoxContainer/Resume
onready var options_button := $VBoxContainer/Options
onready var quit_button := $VBoxContainer/Quit
onready var select_sfx := $SelectSFX
onready var options_menu = OptionsMenu.get_node("Control")


func _ready() -> void:
	visible = false
	
	if OS.get_name() == "HTML5":
		quit_button.visible = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_pause") and Globals.can_pause:
		pause()


func pause() -> void:
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused
	options_menu.visible = false
	$VBoxContainer.visible = true
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		resume_button.grab_focus()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_Resume_pressed() -> void:
	select_sfx.play()
	pause()


func _on_Restart_pressed() -> void:
	RespawnManager.respawn()
	pause()


func _on_Options_pressed() -> void:
	select_sfx.play()
	$VBoxContainer.visible = false
	options_menu.appear()


func options_turn_off() -> void:
	$VBoxContainer.visible = true
	options_button.grab_focus()


func _on_Quit_pressed() -> void:
	get_tree().quit()
