extends Area2D

@export var bullet_scene: PackedScene
var speed = 300

var fire_rate = 0.7
var can_shoot = true
var laser_sound = preload("res://sounds/laser.wav")
var audio_player = AudioStreamPlayer.new()

# _ready runs once, right as the game starts
func _ready():
	# Get the size of the game window
	var screen_size = get_viewport_rect().size
	
	# Place player in the middle (X) and near the bottom (Y)
	position.x = screen_size.x / 2
	position.y = screen_size.y - 40 

	audio_player.stream = laser_sound
	audio_player.volume_db = -15.0
	add_child(audio_player)

func _process(delta):
	# Movement
	var direction = Input.get_axis("ui_left", "ui_right")
	position.x += direction * speed * delta

	# Keep player on screen
	position.x = clamp(position.x, 20, get_viewport_rect().size.x - 20)

	# Shooting
	# Changed to "is_action_pressed" so the player can hold the button to auto-fire
	if Input.is_action_pressed("ui_accept") and can_shoot:
		shoot()

func shoot():
	if bullet_scene:
		# Spawn the bullet
		var bullet = bullet_scene.instantiate()
		bullet.position = position
		get_parent().add_child(bullet)
		
		# Play the laser sound
		audio_player.play()
		
		# Trigger the cooldown delay
		can_shoot = false
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true
		
# Tämä funktio suoritetaan, kun vihollisen ammus osuu
func ota_vahinkoa():
	print("Pelaajaan osui!")
	# Aloitetaan peli alusta 
	get_tree().reload_current_scene()
