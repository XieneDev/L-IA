extends Control


onready var play_button := $VBoxContainer/Play
onready var quit_button := $VBoxContainer/Quit
onready var options_button := $VBoxContainer/Options
onready var select_sfx := $SelectSFX
onready var options_menu = OptionsMenu.get_node("Control")


func _ready() -> void:
	Globals.can_pause = false
	play_button.grab_focus()
	
	if OS.get_name() == "HTML5":
		quit_button.visible = false
		InputMap.action_erase_event("ui_pause", InputMap.get_action_list("ui_pause")[3])
	
	options_menu.connect("turn_off", self, "options_turn_off")


func _on_Play_pressed() -> void:
	select_sfx.play()
	SceneManager.load_level(0)
	options_menu.connect("turn_off", PauseMenu.get_node("Control"), "options_turn_off")
	options_menu.disconnect("turn_off", self, "options_turn_off")


func _on_Options_pressed() -> void:
	select_sfx.play()
	$VBoxContainer.visible = false
	options_menu.appear()


func options_turn_off() -> void:
	$VBoxContainer.visible = true
	options_button.grab_focus()


func _on_Quit_pressed() -> void:
	get_tree().quit()


func _on_YTButton_pressed() -> void:
	select_sfx.play()
	OS.shell_open("https://www.youtube.com/channel/UC5ZQIuHGBrYmnSwtgTBHgxA")


func _on_ItchButton_pressed() -> void:
	select_sfx.play()
	OS.shell_open("https://xienedev.itch.io/")


func _on_TwitterButton_pressed() -> void:
	select_sfx.play()
	OS.shell_open("https://twitter.com/XieneDev")
