class_name SfxResource
extends Resource

@export var minimum_pitch := 1.0
@export var maximum_pitch := 1.0
@export var stream:AudioStream

var random_generator = RandomNumberGenerator.new()

func play() -> AudioStreamPlayer:
	if minimum_pitch != 1.0 and maximum_pitch != 1.0:
		var pitch = random_generator.randf_range(minimum_pitch, maximum_pitch)
		return SoundManager.play_sound_with_pitch(stream, pitch)
	else:
		return SoundManager.play_sound(stream)
