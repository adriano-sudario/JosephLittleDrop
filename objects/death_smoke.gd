extends CPUParticles3D

func _ready():
	emitting = true
	var time = (lifetime * 2) / speed_scale
	await get_tree().create_timer(time).timeout
	get_tree().reload_current_scene()
