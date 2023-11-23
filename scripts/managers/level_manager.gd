extends Node

signal on_pause
signal on_unpause

var current_level_index = 0
var is_paused = false:
	set(value):
		is_paused = value
		
		if value:
			on_pause.emit()
		else:
			on_unpause.emit()

func get_current_level() -> Level:
	if current_level_index >= LevelData.levels.size():
		current_level_index = LevelData.levels.size() - 1
	
	return LevelData.levels[current_level_index]

func get_level(index:int) -> Level:
	return LevelData.levels[index]
