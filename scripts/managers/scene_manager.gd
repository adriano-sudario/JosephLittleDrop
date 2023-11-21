class_name SceneManager
extends Node3D

static var transition_load = preload("res://scenes/transition.tscn")

static func reload_current(delay = null):
	var transition_scene = transition_load.instantiate()
	var main_loop = Engine.get_main_loop()
	var scene_tree = main_loop as SceneTree
	
	if delay != null:
		await scene_tree.create_timer(delay).timeout
	
	transition_scene.on_transition_end.connect(
		func(_transition):
			scene_tree.reload_current_scene()
	)
	transition_scene.mode = Transition.Mode.IN_OUT
	scene_tree.current_scene.get_parent().add_child(transition_scene)

static func load_packed(scene: PackedScene, delay = null, play_soundtrack = true):
	var transition_scene = transition_load.instantiate()
	var main_loop = Engine.get_main_loop()
	var scene_tree = main_loop as SceneTree;
	
	if delay != null:
		await scene_tree.create_timer(delay).timeout
	
	transition_scene.on_transition_end.connect(
		func(_transition):
			scene_tree.change_scene_to_packed(scene)
			
			if play_soundtrack:
				SoundManager.play_music(Audio.resource.gameplay)
	)
	transition_scene.mode = Transition.Mode.IN_OUT
	scene_tree.current_scene.get_parent().add_child(transition_scene)

static func load_string(scene_path: String, delay = null, play_soundtrack = true):
	var transition_scene = transition_load.instantiate()
	var main_loop = Engine.get_main_loop()
	var scene_tree = main_loop as SceneTree;
	
	if delay != null:
		await scene_tree.create_timer(delay).timeout
	
	transition_scene.on_transition_end.connect(
		func(_transition):
			scene_tree.change_scene_to_file(scene_path)
			
			if play_soundtrack:
				SoundManager.play_music(Audio.resource.gameplay)
	)
	transition_scene.mode = Transition.Mode.IN_OUT
	scene_tree.current_scene.get_parent().add_child(transition_scene)

static func load_next_level(delay = 1.5):
	LevelManager.current_level_index += 1
	
	if LevelManager.current_level_index >= LevelData.levels.size():
		LevelManager.current_level_index = 0
	
	var current_level = LevelManager.get_current_level()
	load_string(current_level.scene_path, delay)
