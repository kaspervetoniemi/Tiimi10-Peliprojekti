extends Area2D

@export var powerup_type: String = "rapid"

var fall_speed: float = 115.0

var float_time: float = 0.0
var base_x: float = 0.0
var spin_speed: float = 1.4

var glow_rect: ColorRect


func _ready() -> void:
	add_to_group("powerups")
	area_entered.connect(_on_area_entered)

	base_x = position.x

	_create_glow()
	_setup_colors()
	_start_idle_animation()


func _process(delta: float) -> void:
	float_time += delta

	# Tippuu alas
	position.y += fall_speed * delta

	# Pieni leijunta sivulle
	position.x = base_x + sin(float_time * 2.2) * 8.0

	# Kevyt pyöriminen
	rotation = sin(float_time * spin_speed) * 0.08

	# Jos menee ruudun ulkopuolelle
	if position.y > get_viewport_rect().size.y + 50:
		queue_free()


func _create_glow() -> void:
	if not has_node("ColorRect"):
		return

	var core_rect: ColorRect = $ColorRect

	# Keskiosa vähän näkyvämmäksi
	core_rect.size = Vector2(18, 18)
	core_rect.position = Vector2(-9, -9)

	# Luodaan hohde taakse automaattisesti
	glow_rect = ColorRect.new()
	glow_rect.name = "GlowRect"
	glow_rect.size = Vector2(34, 34)
	glow_rect.position = Vector2(-17, -17)
	glow_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	glow_rect.z_index = -1
	add_child(glow_rect)

	# Siirretään glow taakse
	move_child(glow_rect, 0)


func _setup_colors() -> void:
	if not has_node("ColorRect"):
		return

	var core_rect: ColorRect = $ColorRect

	if powerup_type == "rapid":
		core_rect.color = Color(1.0, 0.92, 0.15, 1.0)
		if glow_rect != null:
			glow_rect.color = Color(1.0, 0.9, 0.2, 0.30)

	elif powerup_type == "shotgun":
		core_rect.color = Color(0.25, 1.0, 0.45, 1.0)
		if glow_rect != null:
			glow_rect.color = Color(0.25, 1.0, 0.45, 0.28)

	else:
		core_rect.color = Color(1.0, 1.0, 1.0, 1.0)
		if glow_rect != null:
			glow_rect.color = Color(1.0, 1.0, 1.0, 0.22)


func _start_idle_animation() -> void:
	if not has_node("ColorRect"):
		return

	var core_rect: ColorRect = $ColorRect

	var tween := create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	# Sykkivä koko
	tween.tween_property(core_rect, "scale", Vector2(1.18, 1.18), 0.45)
	tween.parallel().tween_property(self, "scale", Vector2(1.08, 1.08), 0.45)

	if glow_rect != null:
		tween.parallel().tween_property(glow_rect, "scale", Vector2(1.35, 1.35), 0.45)
		tween.parallel().tween_property(glow_rect, "modulate", Color(1, 1, 1, 0.75), 0.45)

	tween.tween_property(core_rect, "scale", Vector2(1.0, 1.0), 0.45)
	tween.parallel().tween_property(self, "scale", Vector2(1.0, 1.0), 0.45)

	if glow_rect != null:
		tween.parallel().tween_property(glow_rect, "scale", Vector2(1.0, 1.0), 0.45)
		tween.parallel().tween_property(glow_rect, "modulate", Color(1, 1, 1, 0.45), 0.45)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") or area.name == "Player":
		if area.has_method("apply_powerup"):
			area.apply_powerup(powerup_type)

		_collect_effect()
		return


func _collect_effect() -> void:
	set_process(false)

	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)

	var tween := create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "scale", Vector2(1.8, 1.8), 0.18)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.18)

	await tween.finished
	queue_free()
