class_name StateIdle
extends State

func _walk_condition() -> bool:
	return node.is_moving_on_floor and not node.is_running

func _run_condition() -> bool:
	return node.is_running

func _fall_condition() -> bool:
	return node.gravity < 0 and not node.is_on_floor()

func _winning_condition() -> bool:
	return node.has_won

func enter():
	node.animation.play("idle", 0.5)
	node.particles_trail.emitting = false
