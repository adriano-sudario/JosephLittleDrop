extends Control

@onready var time_text = $TimeText

var elapsed_time := 0.0
var is_counting := false

func _ready():
	var player:Player = $"../Player"
	player.on_vanish.connect(func(): is_counting = false)
	player.on_win.connect(func():
		is_counting = false
		ConfigurationManager.keep_track_on_progress(elapsed_time)
	)
	player.on_begin_run.connect(func(): is_counting = true)

func _process(delta):
	if not is_counting:
		return
	
	elapsed_time += delta
	time_text.text = get_formated_time()

func get_formated_time() -> String:
	var seconds:float = fmod(elapsed_time , 60.0)
	var minutes:int = int(elapsed_time / 60.0) % 60
	var hours:int = int(elapsed_time / 3600.0)
	
	if minutes == 0 and hours == 0:
		return "%04.1f" % seconds
	elif hours == 0:
		return "%02d:%04.1f" % [minutes, seconds]
	
	return "%02d:%02d:%04.1f" % [hours, minutes, seconds]
