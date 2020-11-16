extends Control


var audio := true

onready var fullscreen_button := $VBoxContainer/Fullscreen
onready var audio_button := $VBoxContainer/Audio
onready var select_sfx : AudioStreamPlayer = PauseMenu.get_node("Control/SelectSFX")

signal turn_off


func _ready() -> void:
	visible = false


func appear() -> void:
	visible = true
	fullscreen_button.grab_focus()


func _on_Fullscreen_pressed() -> void:
	select_sfx.play()
	fullscreen_button.text = "Fullscreen: Off" if OS.window_fullscreen else "Fullscreen: On"
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Audio_pressed() -> void:
	if not audio:
		select_sfx.play()
	audio = not audio
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), !audio)
	audio_button.text = "Audio: On" if audio else "Audio: Off"


func _on_Back_pressed() -> void:
	select_sfx.play()
	visible = false
	emit_signal("turn_off")
