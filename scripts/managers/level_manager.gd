class_name LevelManager

static var current_level_index = 0

static func get_current_level() -> Level:
	return LevelData.levels[current_level_index]
