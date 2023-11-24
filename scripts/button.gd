extends Button

@export var emit_on_mid = false

signal on_select

const animation_duration := 0.25
const unfocused_alpha := 0.65
const sides_border_radius := 25
const focused_position_increment := Vector2(-25.0, -1.0)

var random_generator = RandomNumberGenerator.new()
var initial_scale:Vector2
var initial_position = null:
	get:
		if initial_position == null:
			initial_position = position
		
		return initial_position

func _ready():
	initial_scale = scale
	var unfocused_theme = get_unfocused_theme()
	unfocused_theme.bg_color.a = unfocused_alpha
	add_theme_stylebox_override("normal", unfocused_theme)

func get_default_theme() -> StyleBoxFlat:
	var default_theme = StyleBoxFlat.new()
	default_theme.bg_color = Color("7c9cc3")
	default_theme.border_width_top = 5
	default_theme.border_width_bottom = 5
	default_theme.border_width_left = 5
	default_theme.border_width_right = 5
	default_theme.border_color = Color("000000")
	default_theme.expand_margin_left = 10
	default_theme.expand_margin_right = 10
	return default_theme

func get_focused_theme() -> StyleBoxFlat:
	var focused_theme = get_default_theme()
	focused_theme.corner_radius_top_left = 0
	focused_theme.corner_radius_bottom_right = 0
	focused_theme.corner_radius_top_right = 0
	focused_theme.corner_radius_bottom_left = 0
	return focused_theme

func get_unfocused_theme() -> StyleBoxFlat:
	var unfocused_theme = get_default_theme()
	unfocused_theme.corner_radius_top_left = sides_border_radius
	unfocused_theme.corner_radius_bottom_right = sides_border_radius
	unfocused_theme.corner_radius_top_right = sides_border_radius
	unfocused_theme.corner_radius_bottom_left = sides_border_radius
	return unfocused_theme

func focus():
	var animated_theme = get_unfocused_theme()
	add_theme_stylebox_override("normal", animated_theme)
	
	var t = create_tween().set_trans(Tween.TRANS_CUBIC)
	t.tween_property(animated_theme, "corner_radius_top_left", 0, animation_duration)
	t.parallel().tween_property(animated_theme, "corner_radius_bottom_right", 0, animation_duration)
	t.parallel().tween_property(animated_theme, "corner_radius_top_right", 0, animation_duration)
	t.parallel().tween_property(animated_theme, "corner_radius_bottom_left", 0, animation_duration)
	t.parallel().tween_property(animated_theme, "skew:y", random_generator.randf_range(-0.08, 0.08), animation_duration)
	t.parallel().tween_property(animated_theme, "expand_margin_top", 10, animation_duration)
	t.parallel().tween_property(animated_theme, "expand_margin_bottom", 10, animation_duration)
	t.parallel().tween_property(animated_theme, "expand_margin_left", 15, animation_duration)
	t.parallel().tween_property(animated_theme, "expand_margin_right", 15, animation_duration)

func unfocus():
	var animated_theme = get_focused_theme()
	add_theme_stylebox_override("normal", animated_theme)
	
	var t = create_tween().set_trans(Tween.TRANS_CUBIC)
	t.tween_property(animated_theme, "corner_radius_top_left", sides_border_radius, animation_duration)
	t.parallel().tween_property(animated_theme, "corner_radius_bottom_right", sides_border_radius, animation_duration)
	t.parallel().tween_property(animated_theme, "corner_radius_top_right", sides_border_radius, animation_duration)
	t.parallel().tween_property(animated_theme, "corner_radius_bottom_left", sides_border_radius, animation_duration)
	t.parallel().tween_property(animated_theme, "bg_color:a", unfocused_alpha, animation_duration)
	t.parallel().tween_property(animated_theme, "skew:y", 0, animation_duration)
	t.parallel().tween_property(animated_theme, "expand_margin_top", 0, animation_duration)
	t.parallel().tween_property(animated_theme, "expand_margin_bottom", 0, animation_duration)
	t.parallel().tween_property(animated_theme, "expand_margin_left", 10, animation_duration)
	t.parallel().tween_property(animated_theme, "expand_margin_right", 10, animation_duration)

func select():
	var animated_theme = get_focused_theme()
	add_theme_stylebox_override("normal", animated_theme)
	
	var t = create_tween().set_trans(Tween.TRANS_CUBIC)
	t.parallel().tween_property(animated_theme, "expand_margin_top", 5, animation_duration)
	t.parallel().tween_property(animated_theme, "expand_margin_bottom", 5, animation_duration)
	t.parallel().tween_property(animated_theme, "expand_margin_left", 5, animation_duration)
	t.parallel().tween_property(animated_theme, "expand_margin_right", 5, animation_duration)
	t.tween_callback(
		func():
			if emit_on_mid:
				on_select.emit()
			
			t = create_tween().set_trans(Tween.TRANS_CUBIC)
			t.parallel().tween_property(animated_theme, "expand_margin_top", 0, animation_duration)
			t.parallel().tween_property(animated_theme, "expand_margin_bottom", 0, animation_duration)
			t.parallel().tween_property(animated_theme, "expand_margin_left", 10, animation_duration)
			t.parallel().tween_property(animated_theme, "expand_margin_right", 10, animation_duration)
			
			if not emit_on_mid:
				t.tween_callback(func(): on_select.emit())
	)
