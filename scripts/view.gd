class_name ViewCamera
extends Node3D

@export_group("Properties")
@export var target: Node

@export_group("Zoom")
@export var zoom_minimum = 16
@export var zoom_maximum = 4
@export var zoom_speed = 10

@export_group("Rotation")
@export var rotation_speed = 120.0

@export_group("Mouse")
@export var mouse_sensitivity := 0.5

@export_group("Transition Speed")
@export var movement_transition_speed = 4.0
@export var rotation_transition_speed = 6.0
@export var zoom_transition_speed = 8.0

@onready var camera = $Camera

var input:Vector3
var camera_rotation:Vector3
var zoom = 10

func _ready():
	camera_rotation = rotation_degrees

func _physics_process(delta):
	if target == null:
		return
	
	position = position.lerp(target.position, delta * movement_transition_speed)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * rotation_transition_speed)

	camera.position = camera.position.lerp(Vector3(0, 0, zoom), zoom_transition_speed * delta)
	
	handle_input(delta)

func add_glitch():
	var glitch = load("res://objects/glitch_filter.tscn").instantiate()
	camera.add_child(glitch)

func remove_glitch():
	camera.remove_child(camera.get_child(0))

func handle_input(delta):
	if Input.is_action_just_pressed("camera_focus_behind"):
		camera_rotation.y = target.rotation_degrees.y + 180
		return
	
	if Input.is_action_just_pressed("mouse_camera_control"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.is_action_just_released("mouse_camera_control"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		input = Vector3.ZERO
		input.y = Input.get_axis("camera_left", "camera_right")
		input.x = Input.get_axis("camera_up", "camera_down")
	
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	camera_rotation.x = clamp(camera_rotation.x, -80, -10)
	
	zoom = clamp(zoom, zoom_maximum, zoom_minimum)

func _unhandled_input(event):
	var is_mouse_moving = event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	
	if is_mouse_moving:
		input.y = -event.relative.x * mouse_sensitivity
		input.x = -event.relative.y * mouse_sensitivity
