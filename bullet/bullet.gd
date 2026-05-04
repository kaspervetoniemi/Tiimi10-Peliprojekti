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
		# 1. Destroy the alien instantly
		area.queue_free() 
		
		# 2. Turn on our safety flag so the bullet stops moving up
		is_exploding = true
		
		# 3. Make the bullet invisible
		hide()
		
		# 4. Turn off the bullet's collision
		$CollisionShape2D.set_deferred("disabled", true)
		
		# 5. Play the sound
		audio_player.play(1.0)
		await audio_player.finished
		queue_free()
