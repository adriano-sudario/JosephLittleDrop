class_name Player
extends CharacterBody3D

signal on_little_drop_collected
signal on_jump
signal on_interaction
signal on_vanish
signal on_win
signal on_begin_run

@export_subgroup("Properties")
@export var movement_speed = 250
@export var fast_speed_multiplier = 1.75
@export var jump_strength = 7
@export var maximum_jumps = 2
@export var evaporation_rate = 0.15
@export var initial_scale := 1.0
@export var minimum_scale := 0.1
@export var maximum_scale := 1.1
@export var gravity_force := 25.0

@onready var particles_trail = $ParticlesTrail
@onready var model = $Character
@onready var animation = $Character/AnimationPlayer
@onready var view: ViewCamera = $"../View"
@onready var centered_position: Vector3 = $Collider.position
@onready var state_machine = $StateMachine

var current_scale := initial_scale
var movement_velocity: Vector3
var rotation_direction: float
var gravity := 0.0
var was_on_floor := false
var jumps_count := 0
var is_evaporating := true
var is_jump_prevented := false
var is_running := false
var is_moving_on_floor:bool
var has_won := false
var input:Vector3

var has_begun_run := false:
	set(value):
		if not has_begun_run and value:
			on_begin_run.emit()
		
		has_begun_run = value

var can_control:
	set(_value):
		if not _value:
			if not has_won:
				state_machine.change_state_string("idle")
			
			is_running = false
			is_moving_on_floor = false
			movement_velocity = Vector3.ZERO
		can_control = _value

func _ready():
	model.scale = Vector3(initial_scale, initial_scale, initial_scale)
	can_control = true
	LevelManager.on_pause.connect(
		func():
			if state_machine.dictionary.walk.is_current() \
				or state_machine.dictionary.run.is_current():
				state_machine.current_state.footstep_player.stream_paused = true
	)
	LevelManager.on_unpause.connect(
		func():
			if state_machine.dictionary.walk.is_current() \
				or state_machine.dictionary.run.is_current():
				state_machine.current_state.footstep_player.stream_paused = false
	)

func _physics_process(delta):
	if LevelManager.is_paused:
		return
	
	handle_controls(delta)
	handle_gravity(delta)
	handle_movement(delta)
	handle_evaporation(delta)
	handle_death()

func handle_death():
	if position.y < -10 or current_scale < minimum_scale:
		Audio.resource.vanish.play()
		can_control = false
		var death_smoke_scene_path = "res://objects/death_smoke.tscn"
		var death_smoke = load(death_smoke_scene_path).instantiate()
		get_parent().add_child(death_smoke)
		death_smoke.global_position = global_position
		death_smoke.global_position.y += 0.15
		on_vanish.emit()
		queue_free()

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
	if not is_evaporating:
		maintain_current_scale(delta)
		return
	
	current_scale -= evaporation_rate * delta
	particles_trail.scale = current_scale * Vector3.ONE
	maintain_current_scale(delta)

func maintain_current_scale(delta):
	model.scale = model.scale.lerp(Vector3(current_scale, current_scale, current_scale), delta * 10)

func handle_landing():
	if is_on_floor() and gravity > 2 and !was_on_floor:
		model.scale = Vector3(current_scale * 1.25, current_scale * 0.75, current_scale * 1.25)
		Audio.resource.land.play()

func handle_controls(delta):
	if not can_control:
		return
	
	if Input.is_action_just_pressed("respawn"):
		current_scale = 0
	
	input = Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	input = input.rotated(Vector3.UP, view.rotation.y).normalized()
	
	var is_fast:bool
	
	if OS.get_name() == "Web":
		is_fast = Input.is_action_pressed("web_fast")
	else:
		is_fast = Input.is_action_pressed("fast")
	
	var is_moving = input != Vector3.ZERO
	is_moving_on_floor = is_moving and is_on_floor()
	is_running = is_moving and is_fast
	movement_velocity = input * movement_speed * delta
	
	if is_fast:
		movement_velocity *= fast_speed_multiplier
	
	if Input.is_action_just_pressed("jump") and can_jump():
		jump()
	
	if Input.is_action_just_pressed("interact"):
		on_interaction.emit()

func can_jump():
	return jumps_count < maximum_jumps

func jump():
	on_jump.emit(jumps_count)
	
	if not is_jump_prevented:
		Audio.resource.jump.play()
		gravity = -jump_strength
		model.scale = Vector3(current_scale * 0.5, current_scale * 1.5, current_scale * 0.5)
		jumps_count += 1
		state_machine.change_state_string("jump")
	
	is_jump_prevented = false

func handle_gravity(delta):
	gravity += gravity_force * delta
	
	if gravity > 0 and is_on_floor():
		jumps_count = 0
		gravity = 0

func collect_little_drop(value):
	on_little_drop_collected.emit()
	model.scale = Vector3(current_scale * 1.25, current_scale * 0.75, current_scale * 0.75)
	current_scale += value
	
	if current_scale > maximum_scale:
		current_scale = maximum_scale
