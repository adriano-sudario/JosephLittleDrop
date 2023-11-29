class_name Audio
extends Node

static var resource:SoundsResource = preload("res://sounds/resources/sounds_resource.tres")

static var maximum_sfx_volume = 0.7

static var is_on := true:
	set(value):
		if value:
			SoundManager.set_music_volume(1.0)
			SoundManager.set_sound_volume(maximum_sfx_volume)
		else:
			SoundManager.set_music_volume(0.0)
			SoundManager.set_sound_volume(0.0)
		
		is_on = value
