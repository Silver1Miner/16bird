extends Control

onready var jukebox = $Options/Jukebox/Jukebox
onready var gallery = $Options/Gallery
onready var preview = $Preview

func _ready():
	update_jukebox_menu()

func update_jukebox_menu() -> void:
	jukebox.clear()
	for track in Audio.tracks:
		jukebox.add_item(track[0])

func _on_Jukebox_item_selected(index: int) -> void:
	Audio.play_music(index)

func _on_Gallery_item_selected(index: int) -> void:
	print(index)
	preview.visible = true

func _on_Close_pressed():
	preview.visible = false
