extends CanvasLayer

@onready var fade_rect: ColorRect = $FadeRect

var is_transitioning := false


func _ready() -> void:
	layer = 100

	if fade_rect == null:
		push_error("FadeRect puuttuu SceneTransition-scenestä.")
		return

	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_rect.modulate = Color(0, 0, 0, 0)


func transition_to_scene(scene_path: String) -> void:
	if is_transitioning:
		return

	if fade_rect == null:
		get_tree().change_scene_to_file(scene_path)
		return

	is_transitioning = true

	var fade_out := create_tween()
	fade_out.set_trans(Tween.TRANS_SINE)
	fade_out.set_ease(Tween.EASE_IN_OUT)

	fade_out.tween_property(fade_rect, "modulate", Color(0, 0, 0, 1), 1.0)

	await fade_out.finished

	get_tree().change_scene_to_file(scene_path)

	await get_tree().process_frame
	await get_tree().process_frame

	var fade_in := create_tween()
	fade_in.set_trans(Tween.TRANS_SINE)
	fade_in.set_ease(Tween.EASE_IN_OUT)

	fade_in.tween_property(fade_rect, "modulate", Color(0, 0, 0, 0), 1.0)

	await fade_in.finished

	is_transitioning = false
