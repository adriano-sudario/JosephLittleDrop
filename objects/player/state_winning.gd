class_name StateWinning
extends State

func _enter():
	node.can_control = false
	node.animation.play("winning", 0.5)
	node.particles_trail.emitting = false
	Audio.resource.victory.play()
	node.on_win.emit(node.on_level_index)
