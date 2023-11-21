class_name Audio
extends Node

static var is_on := true:
	set(value):
		if value:
			SoundManager.set_music_volume(1.0)
			SoundManager.set_sound_volume(1.0)
		else:
			SoundManager.set_music_volume(0.0)
			SoundManager.set_sound_volume(0.0)
		
		is_on = value
static var resource:SoundsResource = preload("res://sounds/resources/sounds_resource.tres")
