extends CharacterBody3D

signal coin_collected

@export_subgroup("Components")
@export var view: Node3D

@export_subgroup("Properties")
@export var movement_speed = 250
@export var jump_strength = 7
@export var maximum_jumps = 2

@onready var particles_trail = $ParticlesTrail
@onready var sound_footsteps = $SoundFootsteps
@onready var model = $Character
@onready var animation = $Character/AnimationPlayer

var movement_velocity: Vector3
var rotation_direction: float
var gravity := 0.0
var was_on_floor := false
var jumps_count := 0
var coins := 0

func _physics_process(delta):
	handle_controls(delta)
	handle_gravity(delta)
	handle_effects()
	
	var applied_velocity: Vector3
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	velocity = applied_velocity
	move_and_slide()
	
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()
	
	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)
	
	if position.y < -10:
		get_tree().reload_current_scene()
	
	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 10)
	
	if is_on_floor() and gravity > 2 and !was_on_floor:
		model.scale = Vector3(1.25, 0.75, 1.25)
		Audio.play("res://sounds/land.ogg")
	
	was_on_floor = is_on_floor()

func handle_effects():
	particles_trail.emitting = false
	sound_footsteps.stream_paused = true
	
	if is_on_floor():
		if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			animation.play("walk", 0.5)
			particles_trail.emitting = true
			sound_footsteps.stream_paused = false
		else:
			animation.play("idle", 0.5)
	else:
		animation.play("jump", 0.5)

func handle_controls(delta):
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	input = input.rotated(Vector3.UP, view.rotation.y).normalized()
	movement_velocity = input * movement_speed * delta
	
	if Input.is_action_just_pressed("jump") and can_jump():
		Audio.play("res://sounds/jump.ogg")
		jump()

func can_jump():
	return jumps_count < maximum_jumps

func jump():
	gravity = -jump_strength
	model.scale = Vector3(0.5, 1.5, 0.5)
	jumps_count += 1

func handle_gravity(delta):
	gravity += 25 * delta
	
	if gravity > 0 and is_on_floor():
		jumps_count = 0
		gravity = 0

func collect_coin():
	coins += 1
	coin_collected.emit(coins)
