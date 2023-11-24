extends Label

@onready var wavy_canvas = preload("res://shaders/wavy_canvas.gdshader")

@export var emit_on_mid = false

signal on_select

const animation_duration := 0.25
const unfocused_alpha := 0.65
const sides_border_radius := 25
const focused_position_increment := Vector2(-25.0, -1.0)

var random_generator = RandomNumberGenerator.new()
var initial_scale:Vector2
var initial_position = null:
	get:
		if initial_position == null:
			initial_position = position
		
		return initial_position

func _ready():
	initial_scale = scale
	pivot_offset = size / 2

func focus():
	material = ShaderMaterial.new()
	material.shader = wavy_canvas
	var t = create_tween().set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "scale", initial_scale + (Vector2.ONE * 0.2), animation_duration)
	t.parallel().tween_property(self, "rotation_degrees", random_generator.randf_range(-5, 5), animation_duration)

func unfocus():
	material = null
	var t = create_tween().set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "scale", initial_scale, animation_duration)
	t.parallel().tween_property(self, "rotation_degrees", 0, animation_duration)

func select():
	material.shader = wavy_canvas
	var t = create_tween().set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "scale", initial_scale - (Vector2.ONE * 0.2), animation_duration)
	
	t.tween_callback(
		func():
			if emit_on_mid:
				on_select.emit()
			
			t = create_tween().set_trans(Tween.TRANS_CUBIC)
			t.tween_property(self, "scale", initial_scale + (Vector2.ONE * 0.2), animation_duration)
	
			if not emit_on_mid:
				t.tween_callback(func(): on_select.emit())
	)
