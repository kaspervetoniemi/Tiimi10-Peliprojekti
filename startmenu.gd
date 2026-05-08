extends Control

@export var game_scene_path: String = "res://levels/main.tscn"

@onready var start_button: Button = $CenterContainer/Menubox/StartButton
@onready var exit_button: Button = $CenterContainer/Menubox/ExitButton
@onready var title_label: Label = $CenterContainer/Menubox/TitleLabel
@onready var credits_label: Label = $CenterContainer/Menubox/CreditsLabel
@onready var scene_transition = get_node_or_null("/root/SceneTransition")

@onready var laser_shot: ColorRect = $LaserShot

@onready var enemy_1: TextureRect = $Enemy1
@onready var enemy_2: TextureRect = $Enemy2
@onready var enemy_3: TextureRect = $Enemy3

@onready var background_ships: Array[TextureRect] = [
	$BackgroundShip1,
	$BackgroundShip2,
	$BackgroundShip3
]

@onready var ship_trails: Array[ColorRect] = [
	$ShipTrail1,
	$ShipTrail2,
	$ShipTrail3
]


func _ready() -> void:
	randomize()

	start_button.pressed.connect(_on_start_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
   
	_style_title()
	_style_start_button()
	_style_exit_button()
	_style_credits()

	_setup_background_effects()
	_setup_laser()
	_setup_enemies()

	_animate_menu_texts()
	_start_ship_animations()
	_start_laser_loop()
	_animate_enemies()


func _on_start_pressed() -> void:
	if scene_transition != null and scene_transition.has_method("transition_to_scene"):
		scene_transition.transition_to_scene(game_scene_path)
	else:
		get_tree().change_scene_to_file(game_scene_path)


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _style_title() -> void:
	title_label.add_theme_color_override("font_color", Color("#FFF6D5"))
	title_label.add_theme_color_override("font_outline_color", Color.BLACK)
	title_label.add_theme_constant_override("outline_size", 2)


func _style_credits() -> void:
	credits_label.add_theme_color_override("font_color", Color("#FFFFFF"))
	credits_label.add_theme_color_override("font_outline_color", Color.BLACK)
	credits_label.add_theme_constant_override("outline_size", 2)


func _style_exit_button() -> void:
	exit_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	exit_button.custom_minimum_size = Vector2(230, 46)

	exit_button.add_theme_font_size_override("font_size", 24)

	exit_button.add_theme_color_override("font_color", Color.WHITE)
	exit_button.add_theme_color_override("font_hover_color", Color.WHITE)
	exit_button.add_theme_color_override("font_pressed_color", Color.WHITE)
	exit_button.add_theme_color_override("font_focus_color", Color.WHITE)
	exit_button.add_theme_color_override("font_disabled_color", Color.WHITE)

	exit_button.add_theme_color_override("font_outline_color", Color.BLACK)
	exit_button.add_theme_constant_override("outline_size", 3)

	var star_wars_yellow := Color("#FFE81F")
	var hover_yellow := Color("#FFF36A")
	var pressed_yellow := Color("#D6B800")

	var normal_style := StyleBoxFlat.new()
	normal_style.bg_color = star_wars_yellow
	normal_style.content_margin_left = 22
	normal_style.content_margin_right = 22
	normal_style.content_margin_top = 6
	normal_style.content_margin_bottom = 6
	normal_style.border_width_left = 2
	normal_style.border_width_right = 2
	normal_style.border_width_top = 2
	normal_style.border_width_bottom = 2
	normal_style.border_color = Color("#A88700")

	var hover_style := StyleBoxFlat.new()
	hover_style.bg_color = hover_yellow
	hover_style.content_margin_left = 22
	hover_style.content_margin_right = 22
	hover_style.content_margin_top = 6
	hover_style.content_margin_bottom = 6
	hover_style.border_width_left = 2
	hover_style.border_width_right = 2
	hover_style.border_width_top = 2
	hover_style.border_width_bottom = 2
	hover_style.border_color = Color("#FFE81F")

	var pressed_style := StyleBoxFlat.new()
	pressed_style.bg_color = pressed_yellow
	pressed_style.content_margin_left = 22
	pressed_style.content_margin_right = 22
	pressed_style.content_margin_top = 6
	pressed_style.content_margin_bottom = 6
	pressed_style.border_width_left = 2
	pressed_style.border_width_right = 2
	pressed_style.border_width_top = 2
	pressed_style.border_width_bottom = 2
	pressed_style.border_color = Color("#6F5D00")

	var focus_style := StyleBoxFlat.new()
	focus_style.bg_color = star_wars_yellow
	focus_style.content_margin_left = 22
	focus_style.content_margin_right = 22
	focus_style.content_margin_top = 6
	focus_style.content_margin_bottom = 6
	focus_style.border_width_left = 2
	focus_style.border_width_right = 2
	focus_style.border_width_top = 2
	focus_style.border_width_bottom = 2
	focus_style.border_color = Color("#FFE81F")

	exit_button.add_theme_stylebox_override("normal", normal_style)
	exit_button.add_theme_stylebox_override("hover", hover_style)
	exit_button.add_theme_stylebox_override("pressed", pressed_style)
	exit_button.add_theme_stylebox_override("focus", focus_style)


func _style_start_button() -> void:
	start_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	start_button.custom_minimum_size = Vector2(230, 46)

	start_button.add_theme_font_size_override("font_size", 24)

	start_button.add_theme_color_override("font_color", Color.WHITE)
	start_button.add_theme_color_override("font_hover_color", Color.WHITE)
	start_button.add_theme_color_override("font_pressed_color", Color.WHITE)
	start_button.add_theme_color_override("font_focus_color", Color.WHITE)
	start_button.add_theme_color_override("font_disabled_color", Color.WHITE)

	start_button.add_theme_color_override("font_outline_color", Color.BLACK)
	start_button.add_theme_constant_override("outline_size", 3)

	var star_wars_yellow := Color("#FFE81F")
	var hover_yellow := Color("#FFF36A")
	var pressed_yellow := Color("#D6B800")

	var normal_style := StyleBoxFlat.new()
	normal_style.bg_color = star_wars_yellow
	normal_style.content_margin_left = 22
	normal_style.content_margin_right = 22
	normal_style.content_margin_top = 6
	normal_style.content_margin_bottom = 6
	normal_style.border_width_left = 2
	normal_style.border_width_right = 2
	normal_style.border_width_top = 2
	normal_style.border_width_bottom = 2
	normal_style.border_color = Color("#A88700")

	var hover_style := StyleBoxFlat.new()
	hover_style.bg_color = hover_yellow
	hover_style.content_margin_left = 22
	hover_style.content_margin_right = 22
	hover_style.content_margin_top = 6
	hover_style.content_margin_bottom = 6
	hover_style.border_width_left = 2
	hover_style.border_width_right = 2
	hover_style.border_width_top = 2
	hover_style.border_width_bottom = 2
	hover_style.border_color = Color("#FFE81F")

	var pressed_style := StyleBoxFlat.new()
	pressed_style.bg_color = pressed_yellow
	pressed_style.content_margin_left = 22
	pressed_style.content_margin_right = 22
	pressed_style.content_margin_top = 6
	pressed_style.content_margin_bottom = 6
	pressed_style.border_width_left = 2
	pressed_style.border_width_right = 2
	pressed_style.border_width_top = 2
	pressed_style.border_width_bottom = 2
	pressed_style.border_color = Color("#6F5D00")

	var focus_style := StyleBoxFlat.new()
	focus_style.bg_color = star_wars_yellow
	focus_style.content_margin_left = 22
	focus_style.content_margin_right = 22
	focus_style.content_margin_top = 6
	focus_style.content_margin_bottom = 6
	focus_style.border_width_left = 2
	focus_style.border_width_right = 2
	focus_style.border_width_top = 2
	focus_style.border_width_bottom = 2
	focus_style.border_color = Color("#FFE81F")

	start_button.add_theme_stylebox_override("normal", normal_style)
	start_button.add_theme_stylebox_override("hover", hover_style)
	start_button.add_theme_stylebox_override("pressed", pressed_style)
	start_button.add_theme_stylebox_override("focus", focus_style)


func _setup_background_effects() -> void:
	for ship in background_ships:
		ship.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ship.set_anchors_preset(Control.PRESET_TOP_LEFT)

		ship.custom_minimum_size = Vector2(96, 48)
		ship.size = Vector2(96, 48)
		ship.pivot_offset = Vector2(48, 24)

		# Aluksi piiloon ja pois ruudulta, ettei mikään jää vasempaan yläkulmaan.
		ship.position = Vector2(-300, -300)
		ship.modulate = Color(1, 1, 1, 0.0)

	for trail in ship_trails:
		trail.mouse_filter = Control.MOUSE_FILTER_IGNORE
		trail.set_anchors_preset(Control.PRESET_TOP_LEFT)

		trail.color = Color("#F7FBFF")
		trail.size = Vector2(90, 1.5)
		trail.pivot_offset = Vector2(45, 0.75)

		trail.position = Vector2(-300, -300)
		trail.modulate = Color(0.92, 0.97, 1.0, 0.0)


func _setup_laser() -> void:
	laser_shot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	laser_shot.set_anchors_preset(Control.PRESET_TOP_LEFT)

	laser_shot.color = Color("#FF3030")
	laser_shot.size = Vector2(55.0, 3.0)
	laser_shot.pivot_offset = Vector2(27.5, 1.5)
	laser_shot.modulate = Color(1.0, 0.1, 0.1, 0.0)


func _animate_menu_texts() -> void:
	var title_tween := create_tween()
	title_tween.set_loops()
	title_tween.tween_property(title_label, "modulate", Color(1.0, 0.92, 0.45, 1.0), 1.4)
	title_tween.tween_property(title_label, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.4)

	var start_tween := create_tween()
	start_tween.set_loops()
	start_tween.tween_property(start_button, "modulate", Color(1.0, 0.96, 0.55, 1.0), 1.4)
	start_tween.tween_property(start_button, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.4)

	var credits_tween := create_tween()
	credits_tween.set_loops()
	credits_tween.tween_property(credits_label, "modulate", Color(1.0, 0.92, 0.45, 1.0), 1.4)
	credits_tween.tween_property(credits_label, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.4)


func _start_ship_animations() -> void:
	for i in range(background_ships.size()):
		_fly_ship_loop(background_ships[i], ship_trails[i], float(i) * 1.2)


func _fly_ship_loop(ship: TextureRect, trail: ColorRect, delay: float) -> void:
	await get_tree().create_timer(delay).timeout

	while true:
		var screen_size := get_viewport_rect().size

		var start_y := randf_range(70.0, screen_size.y - 70.0)
		var end_y := start_y + randf_range(-20.0, 20.0)

		var ship_start := Vector2(-140.0, start_y)
		var ship_end := Vector2(screen_size.x + 140.0, end_y)

		var duration := randf_range(3.2, 4.8)

		# Alus
		ship.position = ship_start
		ship.rotation = 0.0
		ship.modulate = Color(1, 1, 1, 0.30)

		# Trail aluksen taakse.
		var trail_offset := Vector2(-80.0, 22.0)

		trail.position = ship.position + trail_offset
		trail.rotation = 0.0
		trail.size = Vector2(80.0, 1.5)
		trail.color = Color("#F7FBFF")
		trail.modulate = Color(0.92, 0.97, 1.0, 0.12)

		var move_tween := create_tween()
		move_tween.set_parallel(true)
		move_tween.set_trans(Tween.TRANS_SINE)
		move_tween.set_ease(Tween.EASE_IN_OUT)

		move_tween.tween_property(ship, "position", ship_end, duration)
		move_tween.tween_property(trail, "position", ship_end + trail_offset, duration)

		var fade_tween := create_tween()
		fade_tween.tween_interval(duration * 0.75)
		fade_tween.tween_property(trail, "modulate", Color(0.92, 0.97, 1.0, 0.0), 0.7)

		await move_tween.finished

		ship.position = Vector2(-300, -300)
		ship.modulate = Color(1, 1, 1, 0.0)

		trail.position = Vector2(-300, -300)
		trail.modulate = Color(0.92, 0.97, 1.0, 0.0)

		await get_tree().create_timer(randf_range(1.4, 3.0)).timeout


func _start_laser_loop() -> void:
	_laser_loop()


func _laser_loop() -> void:
	await get_tree().create_timer(1.0).timeout

	while true:
		var screen_size := get_viewport_rect().size

		var chosen_ship: TextureRect = background_ships[randi() % background_ships.size()]

		var laser_start := chosen_ship.position + Vector2(80.0, 24.0)
		var laser_end := Vector2(screen_size.x + 120.0, laser_start.y + randf_range(-12.0, 12.0))

		laser_shot.position = laser_start
		laser_shot.rotation = deg_to_rad(randf_range(-1.5, 1.5))
		laser_shot.size = Vector2(55.0, 3.0)
		laser_shot.color = Color("#FF3030")
		laser_shot.modulate = Color(1.0, 0.08, 0.08, 0.65)

		var tween := create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		# Laserin nopeus
		tween.tween_property(laser_shot, "position", laser_end, 0.75)
		tween.tween_property(laser_shot, "modulate", Color(1.0, 0.08, 0.08, 0.0), 0.22)

		# Laserin tahti
		await tween.finished
		await get_tree().create_timer(randf_range(0.8, 0.35)).timeout

func _setup_enemies() -> void:
	enemy_1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	enemy_2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	enemy_3.mouse_filter = Control.MOUSE_FILTER_IGNORE

	enemy_1.set_anchors_preset(Control.PRESET_TOP_LEFT)
	enemy_2.set_anchors_preset(Control.PRESET_TOP_LEFT)
	enemy_3.set_anchors_preset(Control.PRESET_TOP_LEFT)

	enemy_1.size = Vector2(20, 15)
	enemy_2.size = Vector2(20, 15)
	enemy_3.size = Vector2(20, 15)

	enemy_1.pivot_offset = enemy_1.size / 2
	enemy_2.pivot_offset = enemy_2.size / 2
	enemy_3.pivot_offset = enemy_3.size / 2

	var screen_size := get_viewport_rect().size

	enemy_1.position = Vector2(screen_size.x / 2 - 220, 170)
	enemy_2.position = Vector2(screen_size.x / 2 + 70, 171)

	# Vihollinen credits-tekstin yläpuolelle
	enemy_3.position = Vector2(screen_size.x / 2 - 10, 315)

	enemy_1.modulate = Color(1, 1, 1, 0.75)
	enemy_2.modulate = Color(1, 1, 1, 0.75)
	enemy_3.modulate = Color(1, 1, 1, 0.75)


func _animate_enemies() -> void:
	_animate_top_enemies()
	_animate_credit_enemy()


func _animate_top_enemies() -> void:
	var enemy_1_start := enemy_1.position
	var enemy_2_start := enemy_2.position

	var tween := create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	while true:
		tween = create_tween()
		tween.set_parallel(true)
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)

		tween.tween_property(enemy_1, "position", enemy_1_start + Vector2(110, 0), 7.9)
		tween.tween_property(enemy_2, "position", enemy_2_start + Vector2(150, 0), 8.9)

		await tween.finished

		tween = create_tween()
		tween.set_parallel(true)
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)

		tween.tween_property(enemy_1, "position", enemy_1_start, 8.9)
		tween.tween_property(enemy_2, "position", enemy_2_start, 6.9)

		await tween.finished


func _animate_credit_enemy() -> void:
	var enemy_3_start := enemy_3.position

	while true:
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)

		tween.tween_property(enemy_3, "position", enemy_3_start + Vector2(90, 0), 5.0)

		await tween.finished

		tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)

		tween.tween_property(enemy_3, "position", enemy_3_start + Vector2(-80, 0), 8.0)

		await tween.finished

		tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)

		tween.tween_property(enemy_3, "position", enemy_3_start, 9.0)

		await tween.finished
