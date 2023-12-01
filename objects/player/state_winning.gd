class_name StateWinning
extends State

func _idle_condition() -> bool:
	return not node.is_moving_on_floor and node.is_on_floor()

func _walk_condition() -> bool:
	return node.is_moving_on_floor and not node.is_running

func _run_condition() -> bool:
	return node.is_running

func _fall_condition() -> bool:
	return node.gravity < 0 and not node.is_on_floor()

func enter():
	node.animation.play("winning", 0.5)
	node.particles_trail.emitting = false
	Audio.resource.victory.play()
	node.on_win.emit()
