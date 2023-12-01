class_name StateFall
extends State

func _idle_condition() -> bool:
	return not node.is_moving_on_floor and node.is_on_floor()

func _winning_condition() -> bool:
	return node.has_won

func enter():
	node.animation.play("falling", 0.5)
	node.particles_trail.emitting = false
