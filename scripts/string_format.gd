class_name StringFormat

static func get_formated_time(time:float) -> String:
	var seconds:float = fmod(time , 60.0)
	var minutes:int = int(time / 60.0) % 60
	var hours:int = int(time / 3600.0)
	
	if minutes == 0 and hours == 0:
		return "%04.1f" % seconds
	elif hours == 0:
		return "%02d:%04.1f" % [minutes, seconds]
	
	return "%02d:%02d:%04.1f" % [hours, minutes, seconds]
