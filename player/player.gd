extends Area2D

@export var bullet_scene: PackedScene

var speed: float = 300.0

var normal_fire_rate: float = 0.7
var fire_rate: float = 0.7
var can_shoot: bool = true

var current_powerup: String = ""
var powerup_time_left: float = 0.0

var laser_sound = preload("res://sounds/laser.wav")
var audio_player = AudioStreamPlayer.new()


func _ready() -> void:
	add_to_group("player")

	var screen_size = get_viewport_rect().size

	position.x = screen_size.x / 2
	position.y = screen_size.y - 40

	audio_player.stream = laser_sound
	audio_player.volume_db = -15.0
	add_child(audio_player)


func _process(delta: float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	position.x += direction * speed * delta
	position.x = clamp(position.x, 20, get_viewport_rect().size.x - 20)

	if powerup_time_left > 0.0:
		powerup_time_left -= delta

		if powerup_time_left <= 0.0:
			_clear_powerup()

	if Input.is_action_pressed("ui_accept") and can_shoot:
		shoot()


func shoot() -> void:
	if bullet_scene == null:
		return

	if current_powerup == "shotgun":
		_shoot_shotgun()
	else:
		_shoot_normal()

	audio_player.play()

	can_shoot = false
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true


func _shoot_normal() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.position = position

	if bullet.has_method("set_direction"):
		bullet.set_direction(Vector2(0, -1))

	get_parent().add_child(bullet)


func _shoot_shotgun() -> void:
	var directions: Array[Vector2] = [
		Vector2(-0.35, -1).normalized(),
		Vector2(0, -1).normalized(),
		Vector2(0.35, -1).normalized()
	]

	for dir in directions:
		var bullet = bullet_scene.instantiate()
		bullet.position = position

		if bullet.has_method("set_direction"):
			bullet.set_direction(dir)

		get_parent().add_child(bullet)


func apply_powerup(powerup_type: String) -> void:
	current_powerup = powerup_type

	var main_scene = get_tree().current_scene

	if main_scene != null and main_scene.has_method("show_powerup_text"):
		main_scene.show_powerup_text(powerup_type)

	if powerup_type == "rapid":
		fire_rate = 0.18
		powerup_time_left = 6.0
		print("POWER UP: RAPID FIRE")

	elif powerup_type == "shotgun":
		fire_rate = 0.55
		powerup_time_left = 7.0
		print("POWER UP: SHOTGUN")


func _clear_powerup() -> void:
	current_powerup = ""
	fire_rate = normal_fire_rate
	powerup_time_left = 0.0
	print("POWER UP ENDED")


func ota_vahinkoa() -> void:
	print("Pelaajaan osui!")
	Global.score=0
	get_tree().reload_current_scene()


func take_damage(_amount: int = 1) -> void:
	ota_vahinkoa()
