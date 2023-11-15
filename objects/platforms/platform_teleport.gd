class_name PlatformTeleport
extends Platform

@export var shake_force := 3.0
@export var linked_platform:PlatformTeleport
@export var minimum_scale_on_teleport := 0.15
@export var is_active := true

@onready var feedback_drop = $FeedbackDrop
@onready var cube = $Cube
@onready var gpu_particles_3d = $GPUParticles3D

var random_generator = RandomNumberGenerator.new()
var player: Player
var scale_on_teleport := minimum_scale_on_teleport
var initial_feedback_scale:Vector3

func set_active(value: bool, set_linked = true):
	is_active = value
	gpu_particles_3d.visible = value
	
	if set_linked:
		linked_platform.set_active(value, false)

func teleport():
	player.global_position = linked_platform.feedback_drop.global_position
	player.current_scale = scale_on_teleport

func _ready():
	if linked_platform != null:
		linked_platform.linked_platform = self
	
	initial_feedback_scale = feedback_drop.scale
	feedback_drop.scale = Vector3.ZERO
	call_deferred("set_active", is_active, false)

func _process(delta):
	if not is_active:
		return
	
	if player != null:
		linked_platform.cube.rotation_degrees.x = random_generator.randf_range(-shake_force, shake_force)
		linked_platform.cube.rotation_degrees.y = random_generator.randf_range(-shake_force, shake_force)
		linked_platform.cube.rotation_degrees.z = random_generator.randf_range(-shake_force, shake_force)
		scale_on_teleport += player.evaporation_rate * delta
		var current_drop_scale = minimum_scale_on_teleport + scale_on_teleport
		var feedback_drop_scale = Vector3(current_drop_scale, current_drop_scale, current_drop_scale)
		linked_platform.feedback_drop.scale = feedback_drop_scale * initial_feedback_scale

func _on_area_3d_body_entered(body):
	if body is Player and is_active:
		player = body
		player.on_interaction.connect(teleport)
		linked_platform.gpu_particles_3d.visible = false

func _on_area_3d_body_exited(body):
	if body is Player and player != null:
		player.on_interaction.disconnect(teleport)
		player = null
		linked_platform.cube.rotation_degrees = Vector3.ZERO
		linked_platform.feedback_drop.scale = Vector3.ZERO
		scale_on_teleport = minimum_scale_on_teleport
		linked_platform.gpu_particles_3d.visible = true

func on_activate():
	set_active(true)
