class_name PlatformFalling
extends Platform

var is_falling := false
var gravity_force_applied := 0.0

func _process(delta):
	super._process(delta)
	handle_fall(delta)

func handle_fall(delta):
	position.y -= gravity_force_applied * delta
	
	if position.y < -10:
		queue_free()
	
	if is_falling:
		gravity_force_applied += 0.25

func _on_body_entered(body):
	super._on_body_entered(body)
	
	if not body is Player:
		return
	
	if !is_falling:
		SoundManager.play_sound(Audio.resource.fall)
#		Audio.play("res://sounds/fall.ogg")
		scale = current_scale * Vector3(1.25, 1, 1.25)
	
	is_falling = true
