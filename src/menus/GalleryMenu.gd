extends Control

onready var jukebox = $Options/Jukebox/Jukebox
onready var gallery = $Options/Gallery
onready var preview = $Preview
var preview_indices = []
var current_selection = 0

func _ready():
	preview.visible = false
	update_jukebox_menu()
	update_gallery()

func update_jukebox_menu() -> void:
	jukebox.clear()
	for track in Audio.tracks:
		jukebox.add_item(track[0])

func _on_Jukebox_item_selected(index: int) -> void:
	Audio.play_music(index)

func update_gallery() -> void:
	gallery.clear()
	for i in Settings.gallery_owned:
		preview_indices.append(i)
		gallery.add_item(Images.get_gallery_image(i)[0]) # 0 title 1 image

func _on_Gallery_item_selected(index: int) -> void:
	current_selection = index
	set_preview(Images.get_gallery_image(preview_indices[current_selection]))
	preview.visible = true

func set_preview(data: Array) -> void:
	$Preview/Label.text = data[0]
	$Preview/TextureRect.texture = data[1]
	$Preview/SelectBackground.disabled = (preview_indices[current_selection] == Settings.current_training_image_index)

func _on_Close_pressed():
	preview.visible = false
	gallery.release_focus()

func _on_SelectBackground_pressed():
	Settings.current_training_image_index = preview_indices[current_selection]
	$Preview/SelectBackground.disabled = true
