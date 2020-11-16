extends Node2D

const BEAT_TIME := 1.0
var beat_timer : float = BEAT_TIME

const TRANSITION_TIME := 0.25

signal beat


func _process(delta: float) -> void:
	beat_timer -= delta
	if beat_timer <= 0:
		beat_timer += BEAT_TIME
		emit_signal("beat")
