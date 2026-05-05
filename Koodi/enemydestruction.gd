extends Area2D

@export var death_screen : Texture2D

func death():
	# eristetään muusta
	remove_from_group("aliens")
	set_process(false)
	
	# käydään läpi kaikki childnodet
	for child in get_children():
		if child is Sprite2D:
			if child.name == "Destruction":
				# kuolema kuva
				child.texture = death_screen
				child.visible = true
				child.hframes = 1 # nollaus
				child.frame = 0
			else:
				# piiloon että kuolema kuva näkyy
				child.visible = false

	# 3. estetään uudet osumat
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	# 4. odottaa hetken ja poistaa kuolemaruudun
	await get_tree().create_timer(0.4).timeout
	queue_free()
