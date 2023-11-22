class_name MainMenu
extends Control

@onready var buttons_container = $ButtonsContainer

var buttons = null
var button_focused_index := 0

func _ready():
	SoundManager.play_music(Audio.resource.menu)
	$ButtonsContainer/PlayButton.on_select.connect(
		func():
			var current_level = LevelManager.get_current_level()
			SceneManager.load_string(current_level.scene_path)
	)
	$ButtonsContainer/OptionsButton.on_select.connect(
		func():
			SceneManager.load_string("res://scenes/options_menu.tscn", null, false)
	)
	$ButtonsContainer/QuitButton.on_select.connect(
		func():
			get_tree().quit()
	)

func change_next(next: int):
	var previous_focused:Button = buttons[button_focused_index]
	previous_focused.unfocus()
	
	button_focused_index += next
	
	if button_focused_index < 0:
		button_focused_index = buttons.size() - 1
	elif button_focused_index >= buttons.size():
		button_focused_index = 0
	
	var focused_button:Button = buttons[button_focused_index]
	focused_button.focus()

func _process(_delta):
	if buttons == null:
		buttons = buttons_container.get_children()
		button_focused_index = buttons.size() - 1
		change_next(1)
	
	if Input.is_action_just_pressed("ui_down"):
		change_next(1)
	
	if Input.is_action_just_pressed("ui_up"):
		change_next(-1)
	
	if Input.is_action_just_pressed("ui_accept"):
		buttons[button_focused_index].select()
