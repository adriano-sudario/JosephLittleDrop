class_name OptionsMenu
extends Control

@onready var options_container = $OptionsContainer

var options = null
var option_focused_index := 0
var is_transitioning := false

func _ready():
	var sound_container = $OptionsContainer/SoundContainer
	sound_container.on_check.connect(
		func(value): ConfigurationManager.set_audio_on(value)
	)
	sound_container.on_select.connect(
		func(): sound_container.is_checked = !sound_container.is_checked
	)
	sound_container.is_checked = ConfigurationManager.options.is_audio_on
	
	var fullscreen_container = $OptionsContainer/FullscreenContainer
	fullscreen_container.on_select.connect(
		func(): fullscreen_container.is_checked = !fullscreen_container.is_checked
	)
	fullscreen_container.on_check.connect(
		func(value): ConfigurationManager.set_fullscreen(value)
	)
	fullscreen_container.is_checked = ConfigurationManager.options.is_fullscreen
	
	var back_container = $OptionsContainer/BackContainer
	back_container.on_select.connect(
		func():
			is_transitioning = true
			ConfigurationManager.save_options()
			Audio.resource.interface_back.play()
			SceneManager.load_string("res://scenes/main_menu.tscn", null, false)
	)

func change_next(next: int):
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
	
	if options == null:
		options = options_container.get_children()
		option_focused_index = options.size() - 1
		change_next(1)
	
	if Input.is_action_just_pressed("ui_down"):
		Audio.resource.interface_select.play()
		change_next(1)
	
	if Input.is_action_just_pressed("ui_up"):
		Audio.resource.interface_select.play()
		change_next(-1)
	
	if Input.is_action_just_pressed("ui_accept"):
		Audio.resource.interface_enter.play()
		options[option_focused_index].select()
