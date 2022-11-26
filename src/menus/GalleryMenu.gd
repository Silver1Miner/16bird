extends Control

onready var jukebox = $Options/Jukebox/Jukebox
onready var gallery_folders = $Options/GalleryFolders
onready var gallery_cliche = $Options/GalleryFolders/Cliches
onready var gallery_bird = $Options/GalleryFolders/Birds
#onready var gallery_anime = $Options/GalleryFolders/Anime
onready var preview = $Preview
var preview_indices = []
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
	jukebox.selected = UserData.jukebox_index

func _on_Jukebox_item_selected(index: int) -> void:
	Audio.play_music(index)
	UserData.jukebox_index = index
	UserData.save_settings()

func update_galleries() -> void:
	gallery_cliche.clear()
	for i in UserData.current_level:
		var title_string = Images.get_level(i)[0]
		if len(title_string) > 36:
			title_string = title_string.left(36) + "..."
		gallery_cliche.add_item(title_string)
		gallery_cliche.set_item_tooltip_enabled(i, false)
	gallery_bird.clear()
	#gallery_anime.clear()
	var j = 0
	preview_indices.clear()
	for i in UserData.inventory:
		preview_indices.append(i)
		var title_string = Images.get_gallery_image(i)[0]
		if len(title_string) > 36:
			title_string = title_string.left(36) + "..."
		gallery_bird.add_item(title_string) # 0 title 1 image
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
	set_preview(Images.get_gallery_image(preview_indices[current_selection]))
	preview.visible = true
	$Preview/SelectBackground.disabled = false

func _on_Anime_item_selected(index):
	current_folder = 2
	current_selection = index
	set_preview(Images.get_gallery_image(preview_indices[current_selection]))
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
	UserData.current_training_image_folder = current_folder
	if current_folder == 1:
		UserData.current_training_image_index = preview_indices[current_selection]
	else:
		UserData.current_training_image_index = current_selection
	$Preview/SelectBackground.disabled = true

func _on_GalleryFolders_tab_changed(tab: int):
	current_folder = tab
