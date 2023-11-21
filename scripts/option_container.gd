class_name OptionContainer
extends HBoxContainer

@onready var label:Label = $Label
@onready var wavy_canvas = preload("res://shaders/wavy_canvas.gdshader")

@export var is_focused: bool:
	set(value):
		is_focused = value
		
		if is_focused:
			focus()
		else:
			unfocus()

signal on_select

const animation_duration := 0.25
const unfocused_alpha := 0.5

func _ready():
	label.modulate.a = unfocused_alpha

func focus():
	label.material = ShaderMaterial.new()
	label.material.shader = wavy_canvas
	var t = create_tween().set_trans(Tween.TRANS_CUBIC)
	t.tween_property(label, "modulate:a", 1.0, animation_duration)
	return t

func unfocus():
	label.material = null
	label.modulate.a = unfocused_alpha

func select():
	on_select.emit()
