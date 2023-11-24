extends Control

@onready var pause_options_container = $PauseOptionsContainer

var options = null
var option_focused_index := 0
var is_transitioning := false

func open():
	LevelManager.is_paused = true
	visible = true

func close():
	LevelManager.is_paused = false
	visible = false

func toggle():
	if visible:
		close()
	else:
		open()

func _ready():
	close()
	
	$PauseOptionsContainer/ResumeContainer.on_select.connect(func(): close())
	
	$PauseOptionsContainer/LevelSelectContainer.on_select.connect(
		func():
			is_transitioning = true
			LevelManager.current_level_index = LevelData.levels.size() - 1
			SceneManager.load_string("res://scenes/level_select.tscn")
	)
	
	$PauseOptionsContainer/QuitGameContainer.on_select.connect(
		func(): get_tree().quit()
	)

func change_focus_next(next: int):
	var previous_focused = options[option_focused_index]
	previous_focused.is_focused = false
	
	option_focused_index += next
	
	if option_focused_index < 0:
		option_focused_index = options.size() - 1
	elif option_focused_index >= options.size():
		option_focused_index = 0
	
	var focused_option = options[option_focused_index]
	focused_option.is_focused = true

func _process(_delta):
	if is_transitioning:
		return
	
	if Input.is_action_just_pressed("pause_menu"):
		toggle()
	
	if not visible:
		return
	
	if options == null:
		options = pause_options_container.get_children()
		option_focused_index = options.size() - 1
		change_focus_next(1)
	
	if Input.is_action_just_pressed("ui_down"):
		change_focus_next(1)
	
	if Input.is_action_just_pressed("ui_up"):
		change_focus_next(-1)
	
	if Input.is_action_just_pressed("ui_accept"):
		options[option_focused_index].select()
