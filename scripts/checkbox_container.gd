class_name CheckBoxContainer
extends OptionContainer

@onready var check_box = $CheckBox

@export var is_checked: bool:
	get:
		return check_box.button_pressed
	set(value):
		check_box.button_pressed = value
		on_check.emit(value)

signal on_check

func _ready():
	super._ready()
	check_box.modulate.a = unfocused_alpha

func focus():
	super.focus()
	var t = create_tween().set_trans(Tween.TRANS_CUBIC)
	t.parallel().tween_property(check_box, "modulate:a", 1.0, animation_duration)

func unfocus():
	super.unfocus()
	check_box.modulate.a = unfocused_alpha
