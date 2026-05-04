extends Node2D

@export var alien_scene: PackedScene
var alien_direction = 1
var alien_speed = 50

func _ready():
	# Spawn a 10x4 grid of aliens when the game starts
	for row in range(4):
		for col in range(10):
			var alien = alien_scene.instantiate()
			# Space them out nicely
			alien.position = Vector2(col * 60 + 100, row * 40 + 50) 
			add_child(alien)

func _process(delta):
	var aliens = get_tree().get_nodes_in_group("aliens")
	
	if aliens.size() == 0:
		print("YOU WIN!")
		set_process(false) # Stop the game loop
		return

	# Check if any alien hit the edge of the screen
	var hit_edge = false
	for alien in aliens:
		alien.position.x += alien_direction * alien_speed * delta
		if alien.position.x > get_viewport_rect().size.x - 30 or alien.position.x < 30:
			hit_edge = true

	# If they hit the edge, change direction and move them down
	if hit_edge:
		alien_direction *= -1
		for alien in aliens:
			# Nudge them slightly out of the wall so they don't get stuck
			alien.position.x += alien_direction * alien_speed * delta 
			alien.position.y += 20
