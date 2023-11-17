extends Node3D

@export var duration_seconds := 3.0
@export var speed := 1.0

func _ready():
	await get_tree().create_timer(duration_seconds).timeout
	queue_free()

func _process(delta):
	position.y += speed * delta
