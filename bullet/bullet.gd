extends Area2D

var speed = 400
var is_exploding = false

var explosion_sound = preload("res://sounds/explosion.wav")
var audio_player = AudioStreamPlayer.new()

func _ready():
	audio_player.stream = explosion_sound
	add_child(audio_player)
	audio_player.volume_db = -15.0

func _process(delta):
	
	if is_exploding:
		return 

	# Normal movement
	position.y -= speed * delta

	if position.y < 0:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("aliens"):
		
		if area.has_method("death"):
			area.death()
		else:
			area.queue_free()

		Global.score += 10
		print("Score is now: ", Global.score)
		# ------------------------------------------------

		is_exploding = true

		hide()

		$CollisionShape2D.set_deferred("disabled", true)

		audio_player.play(1.0)
		await audio_player.finished
		queue_free()
		
