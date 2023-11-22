class_name LevelContainer
extends Node3D

@onready var preview = $Mesh/Preview

signal on_focused

var index:int
var time := 0.0
var initial_position:Vector3
var initial_rotation:Vector3
var is_locked := false:
	set(value):
		preview.visible = not value
		is_locked = value

var is_focused := false:
	set(value):
		if not value:
			time = 0.0
			var animation_duration := 0.25
			var t = create_tween().set_trans(Tween.TRANS_CUBIC)
			t.tween_property(self, "position", initial_position, animation_duration)
			t.parallel().tween_property(self, "rotation", initial_rotation, animation_duration)
		else:
			on_focused.emit()
		
		is_focused = value

func _ready():
	initial_position = position
	initial_rotation = rotation

func _process(delta):
	if not is_focused:
		return
	
	rotate_y(2 * delta)
	position.y += (cos(time * 5) * 1) * delta
	time += delta
