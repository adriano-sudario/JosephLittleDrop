class_name PlatformToggleVisible
extends Platform

@export var begin_invisible := true

const scale_invisible_tolerance = 0.001
var becoming_invisible := false
var scale_near_zero:
	get: return Vector3(scale_invisible_tolerance, scale_invisible_tolerance, scale_invisible_tolerance)

func _ready():
	super._ready()
	
	if begin_invisible:
		visible = false
		current_scale = scale_near_zero
		scale = current_scale

func _process(delta):
	super._process(delta)
	
	if not becoming_invisible:
		return
	
	if scale <= scale_near_zero:
		becoming_invisible = false
		visible = false

func toggle():
	if visible:
		becoming_invisible = true
		current_scale = scale_near_zero
	else:
		visible = true
		current_scale = initial_scale

func on_activate(player: Player):
	var view_transition_speed = player.view.movement_transition_speed
	player.view.movement_transition_speed = 2.0
	player.can_control = false
	player.is_evaporating = false
	player.view.target = self
	await get_tree().create_timer(1).timeout
	toggle()
	await get_tree().create_timer(1).timeout
	player.can_control = true
	player.is_evaporating = true
	player.view.movement_transition_speed = view_transition_speed
	player.view.target = player
