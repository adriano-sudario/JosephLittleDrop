class_name MainMenu
extends Control

@onready var selections_container = $ButtonsContainer

var speed_lines_noise = preload("res://models/textures/speed_lines_noise.tres")
var selections = null
var selection_focused_index := 0
var has_selected := false

func _ready():
	$Title.material.set_shader_parameter("wave_weight", 15.0)
	$SpeedLines.material.set_shader_parameter("noise", speed_lines_noise)
	SoundManager.play_music(Audio.resource.menu)
	var play:Label = $ButtonsContainer/PlayLabel
	play.on_select.connect(
		func():
			var current_level = LevelManager.get_current_level()
			SceneManager.load_string(current_level.scene_path)
	)
	
	if LevelManager.current_level_index > 0:
		play.text = "Continue"
		
	$ButtonsContainer/LevelSelectLabel.on_select.connect(
		func(): SceneManager.load_string("res://scenes/level_select.tscn", null, false)
	)
	
	$ButtonsContainer/OptionsLabel.on_select.connect(
		func(): SceneManager.load_string("res://scenes/options_menu.tscn", null, false)
	)
	
	$ButtonsContainer/QuitLabel.on_select.connect(func(): get_tree().quit())

func change_next(next: int):
	var previous_focused:Label = selections[selection_focused_index]
	previous_focused.unfocus()
	
	selection_focused_index += next
	
	if selection_focused_index < 0:
		selection_focused_index = selections.size() - 1
	elif selection_focused_index >= selections.size():
		selection_focused_index = 0
	
	var focused_selection:Label = selections[selection_focused_index]
	focused_selection.focus()

func _process(_delta):
	if has_selected:
		return
	
	if selections == null:
		selections = selections_container.get_children()
		selection_focused_index = selections.size() - 1
		change_next(1)
	
	if Input.is_action_just_pressed("ui_right"):
		change_next(1)
	
	if Input.is_action_just_pressed("ui_left"):
		change_next(-1)
	
	if Input.is_action_just_pressed("ui_accept"):
		has_selected = true
		selections[selection_focused_index].select()
