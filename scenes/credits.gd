extends Control

@export var boost_speed := 10.0

@onready var credits_container = $CreditsContainer
@onready var thanks_label = $ThanksLabel
@onready var background = $Background
@onready var engine_container = $EngineContainer

var is_transitioning := false
var has_animation_ended := false
var tween: Tween

func _ready():
	SoundManager.play_music(Audio.resource.credits)
	background.pivot_offset = background.size / 2
	thanks_label.modulate.a = 0
	credits_container.position.y = background.size.y
	var engine_container_end_y = engine_container.position.y
	var engine_container_margin = 150
	engine_container.position.y = credits_container.position.y \
		+ credits_container.size.y + engine_container_margin
	var credits_container_end_y = engine_container_end_y \
		- credits_container.size.y - engine_container_margin
	var thanks_label_end_y = credits_container_end_y - thanks_label.position.y
	
	await get_tree().create_timer(0.5).timeout
	tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(thanks_label, "modulate:a", 1.0, 1.5)
	tween.tween_callback(
		func():
			var roll_up_time = 20.0
			tween = create_tween().set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(\
				engine_container, "position:y", engine_container_end_y, roll_up_time)
			tween.parallel().tween_property(\
				credits_container, "position:y", credits_container_end_y, roll_up_time)
			tween.parallel().tween_property(\
				thanks_label, "position:y", thanks_label_end_y, roll_up_time)
			tween.tween_callback(
				func():
					is_transitioning = true
					SceneManager.load_string("res://scenes/main_menu.tscn", null, false)
			).set_delay(5.0)
	).set_delay(1.5)

func _process(_delta):
	if is_transitioning or tween == null or not tween.is_running():
		return
	
	if Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_cancel"):
		tween.set_speed_scale(boost_speed)
	else:
		tween.set_speed_scale(1.0)
