class_name StringExtension

static func pascal_case_to_snake_case(value: String) -> String:
	var result = ""
	
	for i in value.length():
		var letter = value[i]
		
		if letter == letter.to_upper():
			if i == 0 or letter == "_" or value[i - 1] == "_":
				result += letter.to_lower()
			else:
				result += "_" + letter.to_lower()
		else:
			result += letter
	
	return result

static func get_formated_time(time:float) -> String:
	var seconds:float = fmod(time , 60.0)
	var minutes:int = int(time / 60.0) % 60
	var hours:int = int(time / 3600.0)
	
	if minutes == 0 and hours == 0:
		return "%04.1f" % seconds
	elif hours == 0:
		return "%02d:%04.1f" % [minutes, seconds]
	
	return "%02d:%02d:%04.1f" % [hours, minutes, seconds]
