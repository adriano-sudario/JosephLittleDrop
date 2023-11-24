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

var initial_scale:Vector2

func _ready():
	initial_scale = scale
	pivot_offset = size / 2

func focus():
	label.material = ShaderMaterial.new()
	label.material.shader = wavy_canvas

func unfocus():
	label.material = null

func select():
	on_select.emit()
