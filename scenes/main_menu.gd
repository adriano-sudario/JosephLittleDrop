extends Control

@onready var buttons_container = $ButtonsContainer

var buttons = null
var button_selected_index := 0

func _ready():
	$ButtonsContainer/PlayButton.on_select.connect(
		func():
			SceneManager.load_string("res://scenes/level_intro.tscn")
	)
	$ButtonsContainer/QuitButton.on_select.connect(
		func():
			get_tree().quit()
	)

func focus(next: int):
	var previous_selected:Button = buttons[button_selected_index]
	previous_selected.unfocus()
	
	button_selected_index += next
	
	if button_selected_index < 0:
		button_selected_index = buttons.size() - 1
	elif button_selected_index >= buttons.size():
		button_selected_index = 0
	
	var selected_button:Button = buttons[button_selected_index]
	selected_button.focus()

func _process(_delta):
	if buttons == null:
		buttons = buttons_container.get_children()
		button_selected_index = buttons.size() - 1
		focus(1)
	
	if Input.is_action_just_pressed("ui_down"):
		focus(1)
	
	if Input.is_action_just_pressed("ui_up"):
		focus(-1)
	
	if Input.is_action_just_pressed("ui_accept"):
		buttons[button_selected_index].select()
