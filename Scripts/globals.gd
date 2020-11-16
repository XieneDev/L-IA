extends Node

const GRAV := 700

var core : KinematicBody2D

const colors := 2
var states = [false, false]
var state_controllers = [[], []]

var can_pause := true


func set_state(i, value, obj) -> void:
	if obj:
		if not obj in state_controllers[i]:
			state_controllers[i].append(obj)
	
	if not states[i] and value:
		states[i] = true
	elif states[i] and not value:
		var off = true
		for controller in state_controllers[i]:
			if controller.active:
				off = false
				break
		if off:
			states[i] = false
	
	get_tree().call_group("Observer", "changed_state", i, states[i])


func reset_state() -> void:
	get_tree().call_group("Controller", "reset_state")
	for i in range(0, colors):
		states[i] = false
		get_tree().call_group("Observer", "changed_state", i, false)


func new_level() -> void:
	state_controllers = []
	for _i in range(0, colors):
		state_controllers.append([])
