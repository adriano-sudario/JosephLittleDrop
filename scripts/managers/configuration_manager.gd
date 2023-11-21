extends Node

const data_path = "res://saves/saved_data.json"

var options: OptionsConfiguration

func _ready():
	load_options()

func load_options():
	options = Serializable.load_from_json(data_path) as OptionsConfiguration
	
	if options == null:
		options = OptionsConfiguration.new()
	
	set_audio_on(options.is_audio_on)
	set_fullscreen(options.is_fullscreen)

func save_options():
	options.save_json(data_path)

func set_audio_on(value):
	options.is_audio_on = value
	Audio.is_on = value

func set_fullscreen(value):
	options.is_fullscreen = value
	
	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
