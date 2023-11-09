class_name SceneManager
extends Node3D

static var transition_load = preload("res://scenes/transition.tscn")

static func reload_current():
	var transition_scene = transition_load.instantiate()
	var main_loop = Engine.get_main_loop()
	var scene_tree = main_loop as SceneTree;
	transition_scene.on_transition_end.connect(
		func(_transition):
			scene_tree.reload_current_scene()
	)
	transition_scene.mode = Transition.Mode.IN_OUT
	scene_tree.current_scene.get_parent().add_child(transition_scene)

static func load_packed(scene: PackedScene):
	var transition_scene = transition_load.instantiate()
	var main_loop = Engine.get_main_loop()
	var scene_tree = main_loop as SceneTree;
	transition_scene.on_transition_end.connect(
		func(_transition):
			scene_tree.change_scene_to_packed(scene)
	)
	transition_scene.mode = Transition.Mode.IN_OUT
	scene_tree.current_scene.get_parent().add_child(transition_scene)
