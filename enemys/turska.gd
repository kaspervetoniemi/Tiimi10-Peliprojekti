extends Area2D

@export var ammus_skene: PackedScene
@export var destruction_texture : Texture2D

func _on_timer_timeout():
	# randf() arpoo luvun 0 ja 1 väliltä. 
	# 0.9 tarkoittaa, että vain 10% kerroista turska oikeasti ampuu.
	if randf() > 0.9: 
		if ammus_skene:
			var uusi_ammus = ammus_skene.instantiate()
			get_tree().root.add_child(uusi_ammus)
			uusi_ammus.global_position = global_position
	
	$Timer.wait_time = randf_range(3.0, 10.0)
		
func _ready():
	# Vihollisen timer ampumiseen
	var ajastin = $Timer 
	
	# Satunnainen aloitusviive
	# Ampumisrytmin sekoitus
	ajastin.wait_time = randf_range(1.5, 6.0)
	ajastin.start()
	
func tuhoa_vihollinen():
	# Pysäytetään ampuminen
	$Timer.stop()
	
	# Vaihdetaan turskan kuva räjähdykseksi
	# Varmista, että Sprite-noden nimi on "Turska"
	if has_node("Turska"):
		$Turska.texture = destruction_texture
	
	# Odotetaan pieni hetki ja poistetaan vihollinen
	await get_tree().create_timer(0.2).timeout
	queue_free()
