class_name Menu
extends Control

@onready var buttons_container = $ButtonsContainer

var buttons = null
var button_focused_index := 0

func focus(next: int):
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
		focus(1)
	
	if Input.is_action_just_pressed("ui_down"):
		focus(1)
	
	if Input.is_action_just_pressed("ui_up"):
		focus(-1)
	
	if Input.is_action_just_pressed("ui_accept"):
		buttons[button_focused_index].select()
