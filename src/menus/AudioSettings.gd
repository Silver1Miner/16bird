extends VBoxContainer

onready var sound_toggle = $Sound/SoundToggle
onready var sound_toggle_2 = $Sound/SoundToggle2
onready var music_toggle = $Music/MusicToggle
onready var music_toggle_2 = $Music/MusicToggle2

func _ready():
	sound_toggle.pressed = !Settings.mute_sound
	music_toggle.pressed = !Settings.mute_music

func _on_SoundToggle_toggled(button_pressed: bool):
	sound_toggle_2.pressed = button_pressed

func _on_SoundToggle2_toggled(button_pressed: bool):
	sound_toggle.pressed = button_pressed
	AudioServer.set_bus_mute(1, !button_pressed)

func _on_MusicToggle_toggled(button_pressed: bool):
	music_toggle_2.pressed = button_pressed

func _on_MusicToggle2_toggled(button_pressed: bool):
	music_toggle.pressed = button_pressed
	AudioServer.set_bus_mute(2, !button_pressed)
