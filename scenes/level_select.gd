extends Node3D

@onready var level_containers = $LevelContainers.get_children()
@onready var level_name_label = $LevelNameHud/LevelNameLabel
@onready var time_counter_hud = $TimeCounterHud
@onready var time_label = $TimeCounterHud/TimeLabel
@onready var view = $View

var current_focused := 0
var is_transitioning := false

func _ready():
	for container_index in level_containers.size():
		var container:LevelContainer = level_containers[container_index]
		container.index = container_index
		container.on_focused.connect(
			func():
				level_name_label.text = LevelManager.get_level(container_index).name
				var best_times = ConfigurationManager.progress.best_times
				var has_best_time = container_index < best_times.size()
				
				if not has_best_time:
					time_label.text = "No best time yet"
					return
				
				var best_time = best_times[container_index]
				var best_time_description = StringFormat.get_formated_time(best_time)
				time_label.text = "Best time: %s" % best_time_description
		)
		
		if container_index == current_focused:
			container.is_focused = true
		
		container.is_locked = container_index > LevelManager.current_level_index

func focus_by_increment(index_increment:int):
	var next_focused = current_focused + index_increment
	
	if next_focused < 0 or next_focused > LevelManager.current_level_index:
		return
	
	var container_previous_focused:LevelContainer = level_containers[current_focused]
	container_previous_focused.is_focused = false
	
	current_focused = next_focused
	var container_focused:LevelContainer = level_containers[current_focused]
	container_focused.is_focused = true

func _process(_delta):
	if is_transitioning:
		return
	
	if Input.is_action_just_pressed("ui_cancel"):
		is_transitioning = true
		SceneManager.load_string("res://scenes/main_menu.tscn", null, false)
		return
	
	if Input.is_action_just_pressed("ui_left"):
		focus_by_increment(-1)
	
	if Input.is_action_just_pressed("ui_right"):
		focus_by_increment(1)
	
	if Input.is_action_just_pressed("ui_down"):
		focus_by_increment(3)
	
	if Input.is_action_just_pressed("ui_up"):
		focus_by_increment(-3)
	
	if Input.is_action_just_pressed("ui_accept"):
		is_transitioning = true
		level_name_label.visible = false
		time_counter_hud.visible = false
		view.target = level_containers[current_focused]
		view.zoom = view.zoom_maximum
		SceneManager.load_level(current_focused, 0.5)
