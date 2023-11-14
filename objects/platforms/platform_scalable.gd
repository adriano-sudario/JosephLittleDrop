class_name ScalablePlatform
extends Platform

@export var scale_increment := Vector3(2, 2, 2)
@export var is_big := false

func _ready():
	super._ready()
	var player:Player = $"../../Player"
	player.on_jump.connect(_on_player_jump)

func _on_player_jump(_jumps):
	if is_big:
		current_scale /= scale_increment
	else:
		current_scale *= scale_increment
	
	is_big = not is_big
