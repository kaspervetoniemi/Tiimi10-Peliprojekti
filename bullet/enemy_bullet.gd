extends Area2D

var nopeus = 300

func _process(delta):
	position.y += nopeus * delta

# HUOM: Vaihdettu body -> area
func _on_area_entered(area):
	if area.name == "Player":
		if area.has_method("ota_vahinkoa"):
			area.ota_vahinkoa()
		
		# Poistetaan ammus osuman jälkeen
		queue_free()
