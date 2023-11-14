extends Node3D

@export var next_level: PackedScene

var is_transitioning := false

func _on_body_entered(body):
	if is_transitioning or not body is Player or next_level == null:
		return
	
	SceneManager.load_packed(next_level)
	body.is_evaporating = false
	body.can_control = false
	is_transitioning = true
