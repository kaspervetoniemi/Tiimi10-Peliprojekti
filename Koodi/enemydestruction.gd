extends Area2D

@export var death_screen : Texture2D

func death():
	# 1. Etsitään sprite kokeilemalla eri tapoja
	var sprite = get_node_or_null("Rapu") # Kokeillaan suoraan nimellä, joka näkyi kuvassasi
	
	if sprite == null:
		# Jos nimellä ei löytynyt, etsitään ensimmäinen vastaantuleva sprite
		for child in get_children():
			if child is Sprite2D or child is AnimatedSprite2D:
				sprite = child
				break

	# 2. Jos sprite löytyi, vaihdetaan kuva
	if sprite != null and death_screen != null:
		sprite.texture = death_screen
		sprite.visible = true # Varmistetaan että se on näkyvissä
	else:
		print("Virhe: Spriteä tai Death Screen -kuvaa ei löytynyt!")

	# 3. Loput logiikasta
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.5).timeout
	queue_free()
