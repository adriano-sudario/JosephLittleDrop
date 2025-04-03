extends Node

const password = "jose_gotitos007"

var options: OptionsConfiguration
var progress: Progress

func _ready():
	load_options()
	load_progress()

func get_progress_data_path():
	if OS.get_name() == "Web":
		return "user://joseph_little_drop_progress.bin"
	
	return OS.get_user_data_dir() + "/progress.bin"

func get_options_data_path():
	if OS.get_name() == "Web":
		return "user://joseph_little_drop_config.json"
	
	return OS.get_user_data_dir() + "/config.json"

func keep_track_on_progress(level_index: int, time: float):
	if level_index == progress.best_times.size():
		progress.best_times.push_back(time)
		save_progress()
	elif time < progress.best_times[level_index]:
		progress.best_times[level_index] = time
		save_progress()

func load_progress():
	progress = Serializable.load_from_encrypted(get_progress_data_path(), password) as Progress
	
	if progress == null:
		progress = Progress.new()
	
	LevelManager.current_level_index = progress.best_times.size()

func save_progress():
	progress.save_encrypted(get_progress_data_path(), password)

func load_options():
	options = Serializable.load_from_json(get_options_data_path()) as OptionsConfiguration
	
	if options == null:
		options = OptionsConfiguration.new()
	
	set_audio_on(options.is_audio_on)
	set_fullscreen(options.is_fullscreen)

func save_options():
	options.save_json(get_options_data_path())

func set_audio_on(value):
	options.is_audio_on = value
	Audio.is_on = value

func set_fullscreen(value):
	options.is_fullscreen = value
	
	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
