class_name Transition
extends CanvasLayer

enum Mode { IN, OUT, IN_OUT, OUT_IN }

@export var duration_milliseconds := 1.5
@export var call_back_once := true

@onready var dissolve_rect:ColorRect = $DissolveRect

signal on_transition_end

var progress := 0.0
var mode := Mode.IN
var end_count := 0

func configure_tween():
	var end_value: float
	
	if mode == Mode.OUT or mode == Mode.OUT_IN:
		progress = 0.0
		end_value = 1.0
	else:
		progress = 1.0
		end_value = 0.0
	
	var tween_callback = func():
		if not call_back_once or end_count == 0:
			on_transition_end.emit(self)
		
		end_count += 1
		
		if mode == Mode.IN_OUT or mode == Mode.OUT_IN:
			if mode == Mode.IN_OUT:
				mode = Mode.OUT
			else:
				mode = Mode.IN
			
			configure_tween()
		else:
			queue_free()
	
	var t = create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "progress", end_value, duration_milliseconds)
	t.tween_callback(tween_callback)

func _ready():
	dissolve_rect.material.set_shader_parameter("screen_width", dissolve_rect.size.x)
	dissolve_rect.material.set_shader_parameter("screen_height", dissolve_rect.size.y)
	configure_tween()

func _process(_delta):
	dissolve_rect.material.set_shader_parameter("circle_size", progress)
