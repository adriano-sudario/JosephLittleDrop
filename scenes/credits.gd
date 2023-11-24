extends Control

var is_transitioning := false

func _ready():
	var background = $Background
	background.pivot_offset = background.size / 2

func _process(_delta):
	if is_transitioning:
		return
	
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		is_transitioning = true
		SceneManager.load_string("res://scenes/main_menu.tscn", null, false)
