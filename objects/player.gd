extends CharacterBody3D

signal coin_collected

@export_subgroup("Components")
@export var view: Node3D

@export_subgroup("Properties")
@export var movement_speed = 250
@export var running_speed_multiplier = 1.75
@export var jump_strength = 7
@export var maximum_jumps = 2
@export var evaporation_rate = 0.05
@export var initial_scale := 0.4
@export var minimum_scale := 0.1

@onready var particles_trail = $ParticlesTrail
@onready var sound_footsteps = $SoundFootsteps
@onready var model = $Character
@onready var animation = $Character/AnimationPlayer

var current_scale := initial_scale
var movement_velocity: Vector3
var rotation_direction: float
var gravity := 0.0
var was_on_floor := false
var is_running := false
var jumps_count := 0
var coins := 0

func _ready():
	model.scale = Vector3(initial_scale, initial_scale, initial_scale)

func _physics_process(delta):
	handle_controls(delta)
	handle_gravity(delta)
	handle_effects()
	handle_movement(delta)
	handle_evaporation(delta)
	handle_death()

func handle_death():
	if position.y < -10 or current_scale < minimum_scale:
		get_tree().reload_current_scene()

func handle_movement(delta):
	var applied_velocity: Vector3
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	velocity = applied_velocity
	
	move_and_slide()
	handle_movement_rotation(delta)
	handle_landing()
	
	was_on_floor = is_on_floor()

func handle_movement_rotation(delta):
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()
	
	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)

func handle_evaporation(delta):
	current_scale -= evaporation_rate * delta
	maintain_current_scale(delta)

func maintain_current_scale(delta):
	model.scale = model.scale.lerp(Vector3(current_scale, current_scale, current_scale), delta * 10)

func handle_landing():
	if is_on_floor() and gravity > 2 and !was_on_floor:
		model.scale = Vector3(current_scale * 1.25, current_scale * 0.75, current_scale * 1.25)
		Audio.play("res://sounds/land.ogg")

func handle_effects():
	particles_trail.emitting = false
	sound_footsteps.stream_paused = true
	
	if is_on_floor():
		if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			if is_running:
				animation.play("running", 0.5)
			else:
				animation.play("walk", 0.5)
			
			particles_trail.emitting = true
			sound_footsteps.stream_paused = false
		else:
			animation.play("Idle", 0.5)
#	else:
#		animation.play("jump", 0.5)

func handle_controls(delta):
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	input = input.rotated(Vector3.UP, view.rotation.y).normalized()
	is_running = Input.is_action_pressed("run")
	movement_velocity = input * movement_speed * delta
	
	if is_running:
		movement_velocity *= running_speed_multiplier
	
	if Input.is_action_just_pressed("jump") and can_jump():
		Audio.play("res://sounds/jump.ogg")
		jump()

func can_jump():
	return jumps_count < maximum_jumps

func jump():
	gravity = -jump_strength
	model.scale = Vector3(current_scale * 0.5, current_scale * 1.5, current_scale * 0.5)
	jumps_count += 1

func handle_gravity(delta):
	gravity += 25 * delta
	
	if gravity > 0 and is_on_floor():
		jumps_count = 0
		gravity = 0

func collect_coin(value):
	coins += 1
	coin_collected.emit(coins)
	model.scale = Vector3(current_scale * 1.25, current_scale * 0.75, current_scale * 0.75)
	current_scale += value
