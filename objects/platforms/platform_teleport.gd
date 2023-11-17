class_name PlatformTeleport
extends Platform

@export var shake_force := 3.0
@export var linked_platform:PlatformTeleport
@export var minimum_scale_on_teleport := 0.15
@export var is_active := true
@export var scan_spawn_interval_seconds := 1.0

@onready var feedback_drop = $FeedbackDrop
@onready var cube = $Cube
@onready var scan_controller = $ScanController

var teleport_scan_scene = preload("res://objects/platforms/teleport_scan.tscn")
var glitch_scene = preload("res://objects/glitch_filter.tscn")
var random_generator = RandomNumberGenerator.new()
var player: Player
var is_scanning := false:
	set(value):
		is_scanning = value
		
		if is_scanning:
			scan()
		else:
			for child in scan_controller.get_children():
				child.queue_free()
var scale_on_teleport := minimum_scale_on_teleport
var initial_feedback_scale:Vector3

func scan():
	scan_controller.add_child(teleport_scan_scene.instantiate())
	await get_tree().create_timer(scan_spawn_interval_seconds).timeout
	
	if is_scanning:
		scan()

func set_active(value: bool, set_linked = true):
	is_active = value
	is_scanning = value
	
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
		linked_platform.is_scanning = false

func _on_area_3d_body_exited(body):
	super._on_body_entered(body)
	
	if body is Player and player != null:
		player.on_interaction.disconnect(teleport)
		player = null
		linked_platform.cube.rotation_degrees = Vector3.ZERO
		linked_platform.feedback_drop.scale = Vector3.ZERO
		scale_on_teleport = minimum_scale_on_teleport
		linked_platform.is_scanning = true

func on_activate():
	set_active(true)
