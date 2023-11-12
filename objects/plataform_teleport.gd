class_name PlatformTeleport
extends Platform

@export var shake_force := 3.0
@export var linked_platform:PlatformTeleport
@export var minimum_scale_on_teleport := 0.15

@onready var feedback_drop = $FeedbackDrop
@onready var cube = $Cube

var random_generator = RandomNumberGenerator.new()
var player: Player
var scale_on_teleport := minimum_scale_on_teleport
var initial_feedback_scale:Vector3

func teleport_on_second_jump(jumps_count):
	if jumps_count >= 1:
		player.is_jump_prevented = true
		player.global_position = linked_platform.feedback_drop.global_position
		player.current_scale = scale_on_teleport

func _ready():
	if linked_platform != null:
		linked_platform.linked_platform = self
	
	initial_feedback_scale = feedback_drop.scale
	feedback_drop.scale = Vector3.ZERO

func _process(delta):
	if player != null:
		linked_platform.cube.rotation_degrees.x = random_generator.randf_range(-shake_force, shake_force)
		linked_platform.cube.rotation_degrees.y = random_generator.randf_range(-shake_force, shake_force)
		linked_platform.cube.rotation_degrees.z = random_generator.randf_range(-shake_force, shake_force)
		scale_on_teleport += player.evaporation_rate * delta
		var current_drop_scale = minimum_scale_on_teleport + scale_on_teleport
		var feedback_drop_scale = Vector3(current_drop_scale, current_drop_scale, current_drop_scale)
		linked_platform.feedback_drop.scale = feedback_drop_scale * initial_feedback_scale

func _on_area_3d_body_entered(body):
	if body is Player:
		player = body
		player.on_jump.connect(teleport_on_second_jump)

func _on_area_3d_body_exited(body):
	if body is Player:
		player.on_jump.disconnect(teleport_on_second_jump)
		player = null
		linked_platform.cube.rotation_degrees = Vector3.ZERO
		linked_platform.feedback_drop.scale = Vector3.ZERO
		scale_on_teleport = minimum_scale_on_teleport
