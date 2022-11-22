extends Node

# GALLERY IMAGES
var gallery_dir_start = "res://assets/gallery/"
var current_folder = 0
var current_folder_images = [] # ten images per folder, inices 0-9

func check_valid_image(index: int) -> bool:
	var dir = Directory.new()
# warning-ignore:integer_division
	var i = int(index/10) # folder numbers start from 0
	return dir.dir_exists(gallery_dir_start+str(i))

func get_gallery_image(index: int) -> Array:
# warning-ignore:integer_division
	var folder = int(index/10) # folder numbers start from 0
	var image_index = index % 10
	if folder == current_folder and len(current_folder_images) == 10:
		return current_folder_images[image_index]
	current_folder = folder
	current_folder_images.clear()
	var dir = Directory.new()
	if dir.open(gallery_dir_start + str(current_folder)) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() or file_name == "." or file_name == "..":
				pass
			else:
				var split = file_name.split(".")
				var title = split[0]
				var suffix = split[-1]
				if suffix == "import":
					current_folder_images.append([title,load(gallery_dir_start+str(current_folder)+"/"+file_name.replace(".import",""))])
			file_name = dir.get_next()
		return current_folder_images[image_index]
	else:
		push_error("error in trying to access path")
		return []

# CAMPAIGN LEVELS
var dir_start = "res://assets/campaign/s"
var current_s = 0
var current_s_levels = []

func check_valid_level(level: int) -> bool:
	var dir = Directory.new()
# warning-ignore:integer_division
	var s = int(level/10)+1 # +1 because folder numbers start from 1
	return dir.dir_exists(dir_start + str(s))

func get_level(level: int) -> Array:
# warning-ignore:integer_division
	var s = int(level/10)+1 # +1 because folder numbers start from 1
	var l = level % 10
	if s == current_s and len(current_s_levels) == 10:
		return current_s_levels[l]
	current_s = s
	current_s_levels.clear()
	var dir = Directory.new()
	if dir.open(dir_start + str(s)) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() or file_name == "." or file_name == "..":
				pass
			else:
				var split = file_name.split(".")
				var title = split[0]
				var suffix = split[-1]
				if suffix == "import":
					current_s_levels.append([title,load(dir_start+str(s)+"/"+file_name.replace(".import","")),[],])
			file_name = dir.get_next()
		return current_s_levels[l]
	else:
		push_error("error in trying to access path")
		return []

var training_levels = [
# s1 Training
	[ # 0
		"A journey of a thousand miles begins with the first step", # title
		preload("res://assets/campaign/s1/a journey of a thousand miles begins with the first step.png"), # picture
		[1,2,3,4,5,6,7,8,9,10,11,12,13,14,0,15], # layout
	],
	[ # 1
		"A good beginning makes a good ending", # title
		preload("res://assets/campaign/s1/a good beginning makes a good ending.png"), # picture
		[1,2,3,4,5,6,7,8,9,10,11,12,0,13,14,15], # layout
	],
	[ # 2
		"The tide's beginning to turn", # title
		preload("res://assets/campaign/s1/The tide's beginning to turn.png"), # picture
		[1,2,3,0,5,6,7,4,9,10,11,8,13,14,15,12], # layout
	],
	[ # 3
		"Put Two and Two Together", # title
		preload("res://assets/campaign/s1/two and two together.png"), # picture
		[0,2,3,4,1,6,7,8,5,10,11,12,9,13,14,15], # layout
	],
	[ # 4
		"Hedge your bets", # title
		preload("res://assets/campaign/s1/Hedge your bets.png"), # picture
		[1,2,3,4,5,6,7,8,9,11,14,12,13,10,15,0], # layout
	],
	[ # 5
		"Scraping the bottom of the barrel", # title
		preload("res://assets/campaign/s1/Scraping the bottom of the barrel.png"), # picture
		[1,2,3,4,5,6,7,8,11,10,12,15,9,14,13,0], # layout
	],
	[ # 6
		"His elevator doesn't go to the top floor", # title
		preload("res://assets/campaign/s1/His elevator doesn't go to the top floor.png"), # picture
		[1,2,3,4,12,9,11,10,8,14,13,15,5,7,6,0], # layout
	],
	[ # 7
		"Know which side your bread is buttered on", # title
		preload("res://assets/campaign/s1/Know which side your bread is buttered on.png"), # picture
		[1,15,12,3,5,2,14,7,9,6,11,10,13,8,4,0], # layout
	],
	[ # 8
		"The grass is always greener on the other side", # title
		preload("res://assets/campaign/s1/the grass is always greener on the other side.png"), # picture
		[2,1,7,9,5,6,10,11,4,8,3,12,13,14,15,0], # layout
	],
	[ # 9
		"No More Mr. Nice Guy", # title
		preload("res://assets/campaign/s1/no more nice guy.png"), # picture
		[], # layout
	],
]
