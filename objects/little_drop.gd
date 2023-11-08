extends Area3D

@export var value := 0.15

var time := 0.0
var grabbed := false

func _on_body_entered(body):
	if body.has_method("collect_little_drop") and !grabbed:
		body.collect_little_drop(value)
		Audio.play("res://sounds/coin.ogg")
		$Mesh.queue_free()
		$Particles.emitting = false
		grabbed = true

func _process(delta):
	rotate_y(2 * delta)
	position.y += (cos(time * 5) * 1) * delta
	time += delta
