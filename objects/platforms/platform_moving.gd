class_name PlatformMoving
extends Platform

@export var is_moving := false
@export var moving_speed := 1.0
@export var destination: Vector3

const moving_force_increment := 0.05
const destination_tolerance := 0.5
var initial_position: Vector3
var is_returning := false
var moving_force := 0.0
var player: Player

func _ready():
	super._ready()
	initial_position = position

func change_position(value: Vector3):
	if player != null:
		player.position += value - position
	
	position = value

func update_movement_to(delta, value: Vector3):
	moving_force = min(moving_force + moving_force_increment, 1.0)
	change_position(position.lerp(value, (moving_speed * moving_force) * delta))

func has_arrived_on(value: Vector3):
	return position.distance_to(value) <= destination_tolerance

func _process(delta):
	super._process(delta)
	
	if not is_moving:
		return
	
	if is_returning:
		update_movement_to(delta, initial_position)
		
		if has_arrived_on(initial_position):
			moving_force = 0.0
			is_returning = false
	else:
		update_movement_to(delta, destination)
		
		if has_arrived_on(destination):
			moving_force = 0.0
			is_returning = true

func on_activate():
	is_moving = true

func _on_area_3d_body_entered(body):
	if body is Player:
		player = body

func _on_area_3d_body_exited(body):
	if body is Player:
		player = null
