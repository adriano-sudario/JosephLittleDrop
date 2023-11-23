extends Node3D

@export var duration_seconds := 3.0
@export var speed := 1.0

var elapsed_time := 0.0

func _process(delta):
	if LevelManager.is_paused:
		return
	
	elapsed_time += delta
	
	if elapsed_time >= duration_seconds:
		queue_free()
		return
	
	position.y += speed * delta
