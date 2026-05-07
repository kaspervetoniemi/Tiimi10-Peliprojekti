extends Control

# Haetaan väylien ID:t numerona
@onready var music_bus = AudioServer.get_bus_index("Music")
@onready var sfx_bus = AudioServer.get_bus_index("SFX")

func _on_music_btn_toggled(button_pressed: bool) -> void:
	# button_pressed on tosi, kun nappi on pohjassa (Pressed-kuva näkyy)
	AudioServer.set_bus_mute(music_bus, button_pressed)
	print("Musiikki mykistetty: ", button_pressed)

func _on_sfx_btn_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(sfx_bus, button_pressed)
	print("SFX mykistetty: ", button_pressed)
