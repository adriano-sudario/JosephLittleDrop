extends Control

@onready var time_text = $TimeText

var elapsed_time := 0.0
var is_counting := false
var has_begun_run := false

func _ready():
	var player:Player = $"../Player"
	player.on_vanish.connect(func(): is_counting = false)
	player.on_win.connect(func():
		is_counting = false
		ConfigurationManager.keep_track_on_progress(elapsed_time)
	)
	player.on_begin_run.connect(func(): has_begun_run = true)
	
	LevelManager.on_pause.connect(func(): is_counting = false)
	LevelManager.on_unpause.connect(func(): is_counting = true)

func _process(delta):
	if not is_counting or not has_begun_run:
		return
	
	elapsed_time += delta
	time_text.text = StringFormat.get_formated_time(elapsed_time)
