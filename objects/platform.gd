class_name Platform
extends Node3D

@export var fall_after_landing := false

var falling := false
var gravity_force_applied := 0.0
var initial_scale: Vector3
var current_scale: Vector3

func _ready():
	initial_scale = scale
	current_scale = initial_scale

func _process(delta):
	scale = scale.lerp(current_scale, delta * 10)
	
	if fall_after_landing:
		handle_fall(delta)

func handle_fall(delta):
	position.y -= gravity_force_applied * delta
	
	if position.y < -10:
		queue_free()
	
	if falling:
		gravity_force_applied += 0.25

func _on_body_entered(_body):
	if !falling:
		Audio.play("res://sounds/fall.ogg")
		scale = current_scale * Vector3(1.25, 1, 1.25)
	
	falling = true
