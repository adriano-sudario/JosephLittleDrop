class_name StateRun
extends State

var footstep_player:AudioStreamPlayer

func _idle_condition() -> bool:
	return not node.is_moving_on_floor and node.is_on_floor()

func _walk_condition() -> bool:
	return node.is_moving_on_floor and not node.is_running

func _fall_condition() -> bool:
	return node.gravity < 0 and not node.is_on_floor()

func _winning_condition() -> bool:
	return node.has_won

func enter():
	node.animation.play("running", 0.5)
	node.particles_trail.emitting = true
	footstep_player = Audio.resource.run.play()

func exit():
	node.particles_trail.emitting = false
	footstep_player.stop()
