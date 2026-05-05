extends Area2D

@export var ammus_skene: PackedScene
@export var destruction_texture: Texture2D

var is_dying: bool = false


func _ready() -> void:
	add_to_group("aliens")

	var ajastin = $Timer
	ajastin.wait_time = randf_range(1.5, 6.0)
	ajastin.start()


func _on_timer_timeout() -> void:
	if is_dying:
		return

	if randf() > 0.9:
		if ammus_skene:
			var uusi_ammus = ammus_skene.instantiate()
			get_tree().root.add_child(uusi_ammus)
			uusi_ammus.global_position = global_position

	$Timer.wait_time = randf_range(3.0, 10.0)


func death() -> void:
	tuhoa_vihollinen()


func tuhoa_vihollinen() -> void:
	if is_dying:
		return

	is_dying = true

	if has_node("Timer"):
		$Timer.stop()

	if has_node("Turska"):
		$Turska.texture = destruction_texture
	elif has_node("Rapu"):
		$Rapu.texture = destruction_texture
	elif has_node("Mustekala"):
		$Mustekala.texture = destruction_texture

	await get_tree().create_timer(0.2).timeout
	queue_free()
