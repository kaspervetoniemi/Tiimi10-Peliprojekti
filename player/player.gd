extends Area2D

@export var bullet_scene: PackedScene
var speed = 300

# _ready runs once, right as the game starts
func _ready():
	# Get the size of the game window
	var screen_size = get_viewport_rect().size
	
	# Place player in the middle (X) and near the bottom (Y)
	position.x = screen_size.x / 2
	position.y = screen_size.y - 40 

func _process(delta):
	# Movement
	var direction = Input.get_axis("ui_left", "ui_right")
	position.x += direction * speed * delta

	# Keep player on screen
	position.x = clamp(position.x, 20, get_viewport_rect().size.x - 20)

	# Shooting
	if Input.is_action_just_pressed("ui_accept"):
		shoot()

func shoot():
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		bullet.position = position
		get_parent().add_child(bullet)
