extends "res://addons/sound_manager/abstract_audio_player_pool.gd"


func play(resource: AudioStream, volume := 1.0, override_bus := "") -> AudioStreamPlayer:
	var player = prepare(resource, volume, override_bus)
	player.call_deferred("play")
	return player
