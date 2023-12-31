class_name SceneManager

static var transition_load = preload("res://scenes/transition.tscn")
static var is_transitioning = false

static func reload_current(delay = null):
	is_transitioning = true
	var transition_scene = transition_load.instantiate()
	var main_loop = Engine.get_main_loop()
	var scene_tree = main_loop as SceneTree
	
	if delay != null:
		await scene_tree.create_timer(delay).timeout
	
	Audio.resource.interface_close.play()
	transition_scene.on_transition_end.connect(
		func(_transition):
			scene_tree.reload_current_scene()
			is_transitioning = false
			Audio.resource.interface_open.play()
	)
	transition_scene.mode = Transition.Mode.IN_OUT
	scene_tree.current_scene.get_parent().add_child(transition_scene)

static func load_packed(scene: PackedScene, delay = null, play_soundtrack = true):
	is_transitioning = true
	var transition_scene = transition_load.instantiate()
	var main_loop = Engine.get_main_loop()
	var scene_tree = main_loop as SceneTree;
	
	if delay != null:
		await scene_tree.create_timer(delay).timeout
	
	Audio.resource.interface_close.play()
	transition_scene.on_transition_end.connect(
		func(_transition):
			scene_tree.change_scene_to_packed(scene)
			
			if play_soundtrack:
				SoundManager.play_music(Audio.resource.gameplay)
			
			is_transitioning = false
			Audio.resource.interface_open.play()
	)
	transition_scene.mode = Transition.Mode.IN_OUT
	scene_tree.current_scene.get_parent().add_child(transition_scene)

static func load_string(scene_path: String, delay = null, play_soundtrack = true):
	is_transitioning = true
	var transition_scene = transition_load.instantiate()
	var main_loop = Engine.get_main_loop()
	var scene_tree = main_loop as SceneTree;
	
	if delay != null:
		await scene_tree.create_timer(delay).timeout
	
	Audio.resource.interface_close.play()
	transition_scene.on_transition_end.connect(
		func(_transition):
			scene_tree.change_scene_to_file(scene_path)
			
			if play_soundtrack:
				SoundManager.play_music(Audio.resource.gameplay)
			
			is_transitioning = false
			Audio.resource.interface_open.play()
	)
	transition_scene.mode = Transition.Mode.IN_OUT
	scene_tree.current_scene.get_parent().add_child(transition_scene)

static func load_next_level(delay := 1.5):
	LevelManager.current_level_index += 1
	
	if LevelManager.current_level_index >= LevelData.levels.size():
		LevelManager.current_level_index = LevelData.levels.size() - 1
		SceneManager.load_string("res://scenes/credits.tscn", null, false)
		return
	
	var current_level = LevelManager.get_current_level()
	load_string(current_level.scene_path, delay)

static func load_level(level_index:int, delay := 1.5):
	LevelManager.current_level_index = level_index
	var level = LevelManager.get_level(level_index)
	load_string(level.scene_path, delay)
