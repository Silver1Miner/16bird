extends Control

onready var jukebox = $Options/Jukebox/Jukebox
onready var gallery_folders = $Options/GalleryFolders
onready var gallery_cliche = $Options/GalleryFolders/Cliches
onready var gallery_bird = $Options/GalleryFolders/Birds
onready var preview = $Preview
var bird_preview_indices = []
var current_folder = 0
var current_selection = 0

func _ready():
	update_all()

func update_all() -> void:
	preview.visible = false
	update_jukebox_menu()
	update_galleries()

func update_jukebox_menu() -> void:
	jukebox.clear()
	for track in Audio.tracks:
		jukebox.add_item(track[0])

func _on_Jukebox_item_selected(index: int) -> void:
	Audio.play_music(index)

func update_galleries() -> void:
	gallery_cliche.clear()
	for i in Settings.current_level:
		gallery_cliche.add_item(Images.get_level(i+1)[0])
		gallery_cliche.set_item_tooltip_enabled(i, false)
	gallery_bird.clear()
	var j = 0
	for i in Settings.bird_owned:
		bird_preview_indices.append(i)
		gallery_bird.add_item(Images.get_gallery_image(i)[0]) # 0 title 1 image
		gallery_bird.set_item_tooltip_enabled(j, false)
		j += 1

func _on_Cliche_item_selected(index: int) -> void:
	current_folder = 0
	current_selection = index
	set_preview(Images.get_level(current_selection))
	preview.visible = true
	$Preview/SelectBackground.disabled = false

func _on_Birds_item_selected(index: int) -> void:
	current_folder = 1
	current_selection = index
	set_preview(Images.get_gallery_image(bird_preview_indices[current_selection]))
	preview.visible = true
	$Preview/SelectBackground.disabled = false

func set_preview(data: Array) -> void:
	$Preview/Label.text = data[0]
	$Preview/TextureRect.texture = data[1]

func _on_Close_pressed():
	preview.visible = false
	gallery_cliche.release_focus()
	gallery_bird.release_focus()

func _on_SelectBackground_pressed():
	Settings.current_training_image_folder = current_folder
	if current_folder == 1:
		Settings.current_training_image_index = bird_preview_indices[current_selection]
	else:
		Settings.current_training_image_index = current_selection
	$Preview/SelectBackground.disabled = true

func _on_GalleryFolders_tab_changed(tab: int):
	current_folder = tab
