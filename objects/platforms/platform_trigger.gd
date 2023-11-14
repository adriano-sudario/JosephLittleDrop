class_name PlatformTrigger
extends Platform

@export var linked_platform:Platform
@export var moving_force := 0.5

@onready var button_mesh = $ButtonMesh
@onready var initial_vertical_position: float = button_mesh.position.y

var activated_vertical_offset := -0.3
var activation_lock_vertical_offset := -0.2
var activated_vertical_position:
	get: return snapped(initial_vertical_position + activated_vertical_offset, 0.01)
var activation_lock_vertical_position:
	get: return snapped(initial_vertical_position + activation_lock_vertical_offset, 0.01)
var is_locked:
	get: return button_mesh.position.y <= activation_lock_vertical_position
var player: Player
var has_activated := false

func activate():
	has_activated = true
	
	if linked_platform.has_method("on_activate"):
		linked_platform.on_activate(player)

func _process(delta):
	if has_activated:
		return
	
	if player != null or is_locked:
		button_mesh.position.y = max(button_mesh.position.y - (moving_force * delta), activated_vertical_position)
		
		if button_mesh.position.y <= activated_vertical_position:
			activate()
	else:
		button_mesh.position.y = min(button_mesh.position.y + (moving_force * delta), initial_vertical_position)

func _on_area_3d_body_entered(body):
	if body is Player:
		player = body

func _on_area_3d_body_exited(body):
	if body is Player and not is_locked:
		player = null
