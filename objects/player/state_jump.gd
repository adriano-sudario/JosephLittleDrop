class_name StateJump
extends State

func _idle_condition() -> bool:
	return not node.is_moving_on_floor and node.is_on_floor()

func _fall_condition() -> bool:
	return node.gravity < 0 and not node.is_on_floor()

func _winning_condition() -> bool:
	return node.has_won

func enter():
	node.animation.play("jumping", 0.5)
	node.particles_trail.emitting = false
