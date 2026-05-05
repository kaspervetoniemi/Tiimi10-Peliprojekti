extends Area2D

var speed: float = 400.0
var direction: Vector2 = Vector2(0, -1)

var is_exploding: bool = false

var explosion_sound = preload("res://sounds/explosion.wav")
var audio_player = AudioStreamPlayer.new()


func _ready() -> void:
	audio_player.stream = explosion_sound
	audio_player.volume_db = -15.0
	add_child(audio_player)


func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()


func _process(delta: float) -> void:
	if is_exploding:
		return

	position += direction * speed * delta

	if position.y < -40 or position.x < -40 or position.x > get_viewport_rect().size.x + 40:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("aliens"):
		return

	if area.has_meta("is_boss"):
		var main = get_tree().current_scene

		if main != null and main.has_method("damage_boss"):
			main.damage_boss(25)

		_explode_and_remove()
		return

	var main_scene = get_tree().current_scene

	if main_scene != null and main_scene.has_method("try_spawn_powerup"):
		main_scene.try_spawn_powerup(area.global_position)

	if area.has_method("tuhoa_vihollinen"):
		area.tuhoa_vihollinen()
	elif area.has_method("death"):
		area.death()
	else:
		area.queue_free()

	Global.score += 10
	print("Score is now: ", Global.score)

	_explode_and_remove()


func _explode_and_remove() -> void:
	is_exploding = true
	hide()

	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)

	audio_player.play(1.0)
	await audio_player.finished
	queue_free()
