extends Area2D

# AMPUMISASETUKSET (Näkyvät Inspectorissa)
@export var ammus_skene: PackedScene

# TUHOUTUMISASETUKSET (Näkyvät Inspectorissa)
@export var death_screen : Texture2D

func _ready():
	# alustetaan ajastin vain jos sellainen on olemassa (esim. Turskalla)
	if has_node("Timer"):
		var ajastin = $Timer 
		ajastin.wait_time = randf_range(1.5, 6.0)
		ajastin.start()

func _on_timer_timeout():
	# ampumislogiikka (randf() > 0.9 = 10% mahdollisuus per kierros)
	if randf() > 0.9: 
		if ammus_skene:
			var uusi_ammus = ammus_skene.instantiate()
			get_tree().root.add_child(uusi_ammus)
			uusi_ammus.global_position = global_position
	
	# arvotaan seuraava väli
	if has_node("Timer"):
		$Timer.wait_time = randf_range(3.0, 10.0)

func death():
	# eristetään vihollinen välittömästi
	if is_in_group("aliens"):
		remove_from_group("aliens")
	
	set_process(false)
	
	# pysäytetään ajastin, jos se on olemassa
	if has_node("Timer"):
		$Timer.stop()
	
	# käydään läpi kaikki spritet (dynaaminen haku)
	for child in get_children():
		if child is Sprite2D:
			if child.name == "Destruction":
				# Näytetään kuolemakuvake
				child.texture = death_screen
				child.visible = true
				child.hframes = 1 
				child.frame = 0
			else:
				# piilotetaan elävä vihollinen
				child.visible = false

	# 3. estetään uudet osumat
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	# 4. odotetaan hetki ja poistetaan
	await get_tree().create_timer(0.4).timeout
	queue_free()
