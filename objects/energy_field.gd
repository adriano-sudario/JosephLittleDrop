extends Node3D

@export var next_level: PackedScene
@export var animation_curve: Curve
@export var impact_curve: Curve
@export var animation_time := 1.0
@export var body_rotation_speed := 100.0

@onready var mesh_material: ShaderMaterial = $Mesh.material_override

var elapsed_time := 0.0
var is_animating := false
var player: Player
var body_rotation_degrees = 0.0

func set_impact_origin(_position: Vector3):
	mesh_material.set_shader_parameter("_impact_origin", _position)
	mesh_material.set_shader_parameter("_impact_anim", 0.0)
	is_animating = true
	elapsed_time = 0.0
	body_rotation_degrees = player.rotation_degrees.y

func finish_animation():
	mesh_material.set_shader_parameter("_impact_blend", 0.0)
	mesh_material.set_shader_parameter("_impact_anim", 0.0)
	elapsed_time = 0.0
	is_animating = false

func handle_animation(delta: float):
	elapsed_time += delta
	
	if elapsed_time > animation_time:
		finish_animation()
		return
	
	var normalized_time = elapsed_time / animation_time
	mesh_material.set_shader_parameter("_impact_blend", animation_curve.sample(normalized_time))
	mesh_material.set_shader_parameter("_impact_anim", impact_curve.sample(normalized_time))

func _process(delta):
	if is_animating:
		handle_animation(delta)
	
	if player != null:
		body_rotation_degrees += body_rotation_speed * delta
		player.rotation_degrees.y = body_rotation_degrees

func pull_player_towards_self():
	var fixed_vertical_position = -(0.35 * player.current_scale)
	var center_offset = (player.centered_position * player.current_scale)
	center_offset.y -= fixed_vertical_position
	var global_position_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	global_position_tween.tween_property(player, "position", position - center_offset, 0.5)

func prepare_player(body: Player):
	player = body
	player.gravity_force = 0.0
	player.gravity = 0.0
	var camera_speed = 1.0
	var camera_vertical_look = -10.0
	player.view.zoom = camera_speed
	player.view.rotation_transition_speed = camera_speed
	player.view.camera_rotation.x = camera_vertical_look
	player.view.target = self
	player.is_evaporating = false
	player.can_control = false
	player.has_won = true
	set_impact_origin(player.position)
	pull_player_towards_self()

func _on_body_entered(body):
	if player != null or not body is Player:
		return
	
	prepare_player(body)
	
	if next_level != null:
		SceneManager.load_packed(next_level, 1.5)
