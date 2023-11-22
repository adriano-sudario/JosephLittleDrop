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
	time_text.text = StringFormat.get_formated_time(elapsed_time)
