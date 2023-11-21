extends Node3D

func _on_safe_area_body_entered(body):
	if not body is Player:
		return
	
	body.is_evaporating = false

func _on_safe_area_body_exited(body):
	if not body is Player:
		return
	
	body.is_evaporating = true
	
	if not body.has_begun_run:
		body.has_begun_run = true
