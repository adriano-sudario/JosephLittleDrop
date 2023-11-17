class_name Platform
extends Node3D

@export var tutorial_text := ""

var initial_scale: Vector3
var current_scale: Vector3

func _ready():
	initial_scale = scale
	current_scale = initial_scale

func _process(delta):
	scale = scale.lerp(current_scale, delta * 10)

func _on_body_entered(body):
	if not body is Player or tutorial_text.is_empty():
		return
