extends Control

@onready var music_bus = AudioServer.get_bus_index("Music")
@onready var sfx_bus = AudioServer.get_bus_index("SFX")

func _ready():
	# Haetaan nappien tila sen mukaan, onko äänet jo mykistetty
	$CanvasLayer/HBoxContainer/MusicBtn.button_pressed = AudioServer.is_bus_mute(music_bus)
	$CanvasLayer/HBoxContainer/SFXBtn.button_pressed = AudioServer.is_bus_mute(sfx_bus)

func _on_music_btn_toggled(toggled_on: bool):
	AudioServer.set_bus_mute(music_bus, toggled_on)

func _on_sfx_btn_toggled(toggled_on: bool):
	AudioServer.set_bus_mute(sfx_bus, toggled_on)
