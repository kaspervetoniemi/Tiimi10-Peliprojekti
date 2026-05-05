extends Node2D

@export var alien_scene: PackedScene
@export var powerup_scene: PackedScene

var alien_speed: float = 50.0

var current_boss: Node = null
var boss_health: int = 0
var boss_max_health: int = 0

var is_changing_level: bool = false

var shoot_timer: float = 0.0

var alien_scenes: Array[PackedScene] = [
	preload("res://enemys/rapu.tscn"),
	preload("res://enemys/mustekala.tscn"),
	preload("res://enemys/turska.tscn")
]

var bg_music = preload("res://sounds/backgroundmusic.wav")
var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

@onready var level_manager = $LevelManager
@onready var player: Node2D = $Player
@onready var level_label: Label = $Label
@onready var boss_health_bar: ProgressBar = $BossHealthBar
@onready var level_intro_label: Label = $LevelIntroLabel
@onready var star_background: ColorRect = $CanvasLayer/StarBackground


func _ready() -> void:
	randomize()

	level_manager.level_started.connect(_on_level_started)
	level_manager.game_completed.connect(_on_game_completed)

	boss_health_bar.visible = false
	level_intro_label.visible = false

	_start_music()
	level_manager.start_game()


func _start_music() -> void:
	music_player.stream = bg_music
	music_player.volume_db = -15.0
	add_child(music_player)
	music_player.play()


func _process(delta: float) -> void:
	var aliens: Array = get_tree().get_nodes_in_group("aliens")

	if aliens.size() == 0 and not is_changing_level:
		_start_level_clear_sequence()
		return

	if is_changing_level:
		_move_enemy_bullets(delta)
		return

	_move_floating_aliens(delta)
	_move_boss(delta)
	_enemy_shooting(delta)
	_move_enemy_bullets(delta)


func _on_level_started(level_number: int, is_boss_level: bool) -> void:
	_clear_aliens()
	_clear_enemy_bullets()

	is_changing_level = false
	current_boss = null
	boss_health_bar.visible = false
	level_intro_label.visible = false

	alien_speed = level_manager.get_alien_speed()
	shoot_timer = randf_range(
		level_manager.get_shoot_interval_min(),
		level_manager.get_shoot_interval_max()
	)

	_apply_background_for_level(level_number, is_boss_level)

	if is_boss_level:
		level_label.text = "LEVEL " + str(level_number) + " - BOSS"
		_spawn_boss(level_number)
	else:
		level_label.text = "LEVEL " + str(level_number)
		_spawn_floating_aliens()


func _spawn_floating_aliens() -> void:
	var enemy_count: int = level_manager.get_enemy_count()
	var screen_size: Vector2 = get_viewport_rect().size

	var min_x: float = 70.0
	var max_x: float = screen_size.x - 70.0

	var min_y: float = 65.0
	var max_y: float = screen_size.y * 0.45

	for i in range(enemy_count):
		var enemy_scene: PackedScene = alien_scenes.pick_random()
		var alien = enemy_scene.instantiate()

		alien.position = Vector2(
			randf_range(min_x, max_x),
			randf_range(min_y, max_y)
		)

		if not alien.is_in_group("aliens"):
			alien.add_to_group("aliens")

		var random_direction: Vector2 = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-0.45, 0.45)
		)

		if random_direction.length() < 0.2:
			random_direction = Vector2(1, 0)

		random_direction = random_direction.normalized()

		var personal_speed: float = alien_speed * randf_range(0.65, 1.20)

		alien.set_meta("float_velocity", random_direction * personal_speed)
		alien.set_meta("float_phase", randf_range(0.0, 100.0))

		add_child(alien)


func _move_floating_aliens(delta: float) -> void:
	var aliens: Array = get_tree().get_nodes_in_group("aliens")
	var screen_size: Vector2 = get_viewport_rect().size

	var min_x: float = 35.0
	var max_x: float = screen_size.x - 35.0

	var min_y: float = 55.0

	# Tämä on tärkeä raja:
	# viholliset pysyvät yläpuoliskolla eivätkä valu pelaajan päälle.
	var max_y: float = screen_size.y * 0.50

	for alien in aliens:
		if not is_instance_valid(alien):
			continue

		if alien.has_meta("is_boss"):
			continue

		var velocity: Vector2 = Vector2.ZERO

		if alien.has_meta("float_velocity"):
			velocity = alien.get_meta("float_velocity")
		else:
			velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-0.4, 0.4)).normalized() * alien_speed

		var phase: float = 0.0

		if alien.has_meta("float_phase"):
			phase = float(alien.get_meta("float_phase"))

		var time_value: float = float(Time.get_ticks_msec()) / 1000.0

		var wave_x: float = sin(time_value * 2.0 + phase) * 10.0
		var wave_y: float = cos(time_value * 1.7 + phase) * 5.0

		alien.position += velocity * delta
		alien.position.x += wave_x * delta
		alien.position.y += wave_y * delta

		if alien.position.x < min_x:
			alien.position.x = min_x
			velocity.x = abs(velocity.x)

		if alien.position.x > max_x:
			alien.position.x = max_x
			velocity.x = -abs(velocity.x)

		if alien.position.y < min_y:
			alien.position.y = min_y
			velocity.y = abs(velocity.y)

		if alien.position.y > max_y:
			alien.position.y = max_y
			velocity.y = -abs(velocity.y)

		alien.set_meta("float_velocity", velocity)


func _spawn_boss(level_number: int) -> void:
	var boss_scene: PackedScene = alien_scenes.pick_random()
	var boss = boss_scene.instantiate()

	boss.name = "Boss_Level_" + str(level_number)
	boss.position = Vector2(get_viewport_rect().size.x / 2.0, 120.0)
	boss.scale = Vector2(4.0, 4.0)

	boss.set_meta("is_boss", true)
	boss.set_meta("boss_direction", 1)

	if not boss.is_in_group("aliens"):
		boss.add_to_group("aliens")

	add_child(boss)

	current_boss = boss
	boss_max_health = level_manager.get_boss_health()
	boss_health = boss_max_health

	boss_health_bar.visible = true
	boss_health_bar.min_value = 0
	boss_health_bar.max_value = boss_max_health
	boss_health_bar.value = boss_health


func _move_boss(delta: float) -> void:
	if current_boss == null:
		return

	if not is_instance_valid(current_boss):
		return

	var screen_width: float = get_viewport_rect().size.x
	var direction: int = 1

	if current_boss.has_meta("boss_direction"):
		direction = int(current_boss.get_meta("boss_direction"))

	var boss_speed: float = alien_speed * 0.75

	current_boss.position.x += float(direction) * boss_speed * delta

	if current_boss.position.x < 120.0:
		current_boss.position.x = 120.0
		direction = 1

	if current_boss.position.x > screen_width - 120.0:
		current_boss.position.x = screen_width - 120.0
		direction = -1

	var time_value: float = float(Time.get_ticks_msec()) / 1000.0
	current_boss.position.y = 120.0 + sin(time_value * 1.5) * 18.0

	current_boss.set_meta("boss_direction", direction)


func _enemy_shooting(delta: float) -> void:
	shoot_timer -= delta

	if shoot_timer > 0.0:
		return

	shoot_timer = randf_range(
		level_manager.get_shoot_interval_min(),
		level_manager.get_shoot_interval_max()
	)

	var aliens: Array = get_tree().get_nodes_in_group("aliens")

	if aliens.size() == 0:
		return

	var possible_shooters: Array = []

	for alien in aliens:
		if is_instance_valid(alien):
			possible_shooters.append(alien)

	if possible_shooters.size() == 0:
		return

	var shots_this_wave: int = level_manager.get_max_shots_per_wave()
	shots_this_wave = min(shots_this_wave, possible_shooters.size())

	for i in range(shots_this_wave):
		var shooter = possible_shooters.pick_random()

		if not is_instance_valid(shooter):
			continue

		_spawn_enemy_bullet(shooter.global_position)


func _spawn_enemy_bullet(start_position: Vector2) -> void:
	var bullet := ColorRect.new()

	bullet.name = "EnemyBullet"
	bullet.color = Color(1.0, 0.15, 0.15, 1.0)
	bullet.size = Vector2(4.0, 14.0)
	bullet.position = start_position + Vector2(-2.0, 18.0)
	bullet.mouse_filter = Control.MOUSE_FILTER_IGNORE

	bullet.add_to_group("enemy_bullets")

	var bullet_speed: float = level_manager.get_bullet_speed()
	bullet.set_meta("velocity", Vector2(0.0, bullet_speed))

	add_child(bullet)


func _move_enemy_bullets(delta: float) -> void:
	var bullets: Array = get_tree().get_nodes_in_group("enemy_bullets")
	var screen_height: float = get_viewport_rect().size.y

	for bullet in bullets:
		if not is_instance_valid(bullet):
			continue

		var velocity: Vector2 = Vector2.ZERO

		if bullet.has_meta("velocity"):
			velocity = bullet.get_meta("velocity")

		bullet.position += velocity * delta

		if player != null and is_instance_valid(player):
			var bullet_center: Vector2 = bullet.global_position + Vector2(2.0, 7.0)
			var distance_to_player: float = bullet_center.distance_to(player.global_position)

			if distance_to_player < 28.0:
				if player.has_method("take_damage"):
					player.take_damage(1)

				bullet.queue_free()
				continue

		if bullet.position.y > screen_height + 40.0:
			bullet.queue_free()


func damage_boss(amount: int) -> void:
	if current_boss == null:
		return

	if not is_instance_valid(current_boss):
		return

	boss_health -= amount
	boss_health = max(boss_health, 0)

	boss_health_bar.value = boss_health

	if boss_health <= 0:
		current_boss.queue_free()
		current_boss = null
		boss_health_bar.visible = false


func _clear_aliens() -> void:
	var aliens: Array = get_tree().get_nodes_in_group("aliens")

	for alien in aliens:
		if is_instance_valid(alien):
			alien.queue_free()


func _clear_enemy_bullets() -> void:
	var bullets: Array = get_tree().get_nodes_in_group("enemy_bullets")

	for bullet in bullets:
		if is_instance_valid(bullet):
			bullet.queue_free()


func _start_level_clear_sequence() -> void:
	is_changing_level = true

	var completed_level: int = level_manager.current_level
	var next_level: int = completed_level + 1

	if completed_level >= level_manager.max_level:
		_on_game_completed()
		return

	if completed_level % 5 == 0:
		level_intro_label.text = "BOSS DEFEATED\nNEXT LEVEL " + str(next_level)
	else:
		level_intro_label.text = "LEVEL " + str(completed_level) + " CLEAR\nNEXT LEVEL " + str(next_level)

	var screen_size: Vector2 = get_viewport_rect().size

	level_intro_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level_intro_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	level_intro_label.size = Vector2(700.0, 180.0)
	level_intro_label.position = Vector2(
		screen_size.x / 2.0 - level_intro_label.size.x / 2.0,
		screen_size.y / 2.0 - level_intro_label.size.y / 2.0
	)

	level_intro_label.visible = true
	level_intro_label.modulate = Color(1, 1, 1, 0)

	var fade_in := create_tween()
	fade_in.set_trans(Tween.TRANS_SINE)
	fade_in.set_ease(Tween.EASE_IN_OUT)
	fade_in.tween_property(level_intro_label, "modulate", Color(1, 1, 1, 1), 0.7)

	await fade_in.finished

	await get_tree().create_timer(3.0).timeout

	var fade_out := create_tween()
	fade_out.set_trans(Tween.TRANS_SINE)
	fade_out.set_ease(Tween.EASE_IN_OUT)
	fade_out.tween_property(level_intro_label, "modulate", Color(1, 1, 1, 0), 0.7)

	await fade_out.finished

	level_intro_label.visible = false

	level_manager.next_level()


func _on_game_completed() -> void:
	level_label.text = "YOU WIN!"
	boss_health_bar.visible = false
	level_intro_label.visible = false
	_clear_enemy_bullets()
	set_process(false)


func _apply_background_for_level(level_number: int, is_boss_level: bool) -> void:
	var shader_material := star_background.material as ShaderMaterial

	if shader_material == null:
		return

	var stage: int = level_manager.get_background_stage()

	if is_boss_level:
		if level_number == 5:
			shader_material.set_shader_parameter("green_glow_color", Color(0.55, 0.10, 0.10, 1.0))
			shader_material.set_shader_parameter("green_glow_color_2", Color(0.25, 0.03, 0.03, 1.0))
			shader_material.set_shader_parameter("glow_strength", 0.34)
			shader_material.set_shader_parameter("speed", 0.055)

		elif level_number == 10:
			shader_material.set_shader_parameter("green_glow_color", Color(0.45, 0.12, 0.75, 1.0))
			shader_material.set_shader_parameter("green_glow_color_2", Color(0.20, 0.04, 0.38, 1.0))
			shader_material.set_shader_parameter("glow_strength", 0.38)
			shader_material.set_shader_parameter("speed", 0.06)

		elif level_number == 15:
			shader_material.set_shader_parameter("green_glow_color", Color(0.90, 0.25, 0.05, 1.0))
			shader_material.set_shader_parameter("green_glow_color_2", Color(0.35, 0.06, 0.02, 1.0))
			shader_material.set_shader_parameter("glow_strength", 0.42)
			shader_material.set_shader_parameter("speed", 0.07)

		return

	if stage == 1:
		shader_material.set_shader_parameter("green_glow_color", Color(0.18, 0.55, 0.30, 1.0))
		shader_material.set_shader_parameter("green_glow_color_2", Color(0.05, 0.22, 0.14, 1.0))
		shader_material.set_shader_parameter("glow_strength", 0.22)
		shader_material.set_shader_parameter("speed", 0.03)

	elif stage == 2:
		shader_material.set_shader_parameter("green_glow_color", Color(0.10, 0.42, 0.75, 1.0))
		shader_material.set_shader_parameter("green_glow_color_2", Color(0.03, 0.12, 0.30, 1.0))
		shader_material.set_shader_parameter("glow_strength", 0.24)
		shader_material.set_shader_parameter("speed", 0.038)

	else:
		shader_material.set_shader_parameter("green_glow_color", Color(0.50, 0.18, 0.70, 1.0))
		shader_material.set_shader_parameter("green_glow_color_2", Color(0.18, 0.05, 0.28, 1.0))
		shader_material.set_shader_parameter("glow_strength", 0.27)
		shader_material.set_shader_parameter("speed", 0.045)

func try_spawn_powerup(spawn_position: Vector2) -> void:
	if powerup_scene == null:
		return

	var drop_chance: float = 0.14

	if randf() > drop_chance:
		return

	var powerup = powerup_scene.instantiate()
	powerup.global_position = spawn_position

	var possible_types := ["rapid", "shotgun"]
	powerup.powerup_type = possible_types.pick_random()

	add_child(powerup)
