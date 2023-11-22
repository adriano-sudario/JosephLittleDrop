class_name LevelManager

static var current_level_index = 0

static func get_current_level() -> Level:
	if current_level_index >= LevelData.levels.size():
		current_level_index = LevelData.levels.size() - 1
	
	return LevelData.levels[current_level_index]

static func get_level(index:int) -> Level:
	return LevelData.levels[index]
