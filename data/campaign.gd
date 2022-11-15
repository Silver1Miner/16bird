extends Node

var dir_start = "res://assets/campaign/s"
var current_s = 0
var current_s_levels = []

func check_valid_level(level: int) -> bool:
	var dir = Directory.new()
# warning-ignore:integer_division
	var s = int(level/10)+1
	current_s = s
	return dir.dir_exists(dir_start + str(s))

func get_level(level: int) -> Array:
# warning-ignore:integer_division
	var s = int(level/10)+1
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
					current_s_levels.append([[],title,load(dir_start+str(s)+"/"+file_name.replace(".import",""))])
			file_name = dir.get_next()
		return current_s_levels[l]
	else:
		push_error("error in trying to access path")
		return []

var training_levels = [
# s1 Training
	[ # 0
		[1,2,3,4,5,6,7,8,9,10,11,12,13,14,0,15], # layout
		"A journey of a thousand miles begins with the first step", # title
		preload("res://assets/campaign/s1/a journey of a thousand miles begins with the first step.png"), # picture
	],
	[ # 1
		[1,2,3,4,5,6,7,8,9,10,11,12,0,13,14,15], # layout
		"A good beginning makes a good ending", # title
		preload("res://assets/campaign/s1/a good beginning makes a good ending.png"), # picture
	],
	[ # 2
		[1,2,3,0,5,6,7,4,9,10,11,8,13,14,15,12], # layout
		"The tide's beginning to turn", # title
		preload("res://assets/campaign/s1/The tide's beginning to turn.png"), # picture
	],
	[ # 3
		[0,2,3,4,1,6,7,8,5,10,11,12,9,13,14,15], # layout
		"Put Two and Two Together", # title
		preload("res://assets/campaign/s1/two and two together.png"), # picture
	],
	[ # 4
		[1,2,3,4,5,6,7,8,9,11,14,12,13,10,15,0], # layout
		"Hedge your bets", # title
		preload("res://assets/campaign/s1/Hedge your bets.png"), # picture
	],
	[ # 5
		[1,2,3,4,5,6,7,8,11,10,12,15,9,14,13,0], # layout
		"Scraping the bottom of the barrel", # title
		preload("res://assets/campaign/s1/Scraping the bottom of the barrel.png"), # picture
	],
	[ # 6
		[1,2,3,4,12,9,11,10,8,14,13,15,5,7,6,0], # layout
		"His elevator doesn't go to the top floor", # title
		preload("res://assets/campaign/s1/His elevator doesn't go to the top floor.png"), # picture
	],
	[ # 7
		[1,15,12,3,5,2,14,7,9,6,11,10,13,8,4,0], # layout
		"Know which side your bread is buttered on", # title
		preload("res://assets/campaign/s1/Know which side your bread is buttered on.png"), # picture
	],
	[ # 8
		[2,1,7,9,5,6,10,11,4,8,3,12,13,14,15,0], # layout
		"The grass is always greener on the other side", # title
		preload("res://assets/campaign/s1/the grass is always greener on the other side.png"), # picture
	],
	[ # 9
		[], # layout
		"No More Mr. Nice Guy", # title
		preload("res://assets/campaign/s1/no more nice guy.png"), # picture
	],
]



var levels = [
	[],[],[],[],[],[],[],[],[],[],
# s2 Free
	[ # 10
		"A Bed of Roses", # title
		preload("res://assets/campaign/s2/a bed of roses.png"), # picture
	],
	[ # 11
		"A Bee in Your Bonnet", # title
		preload("res://assets/campaign/s2/a bee in your bonnet.png"), # picture
	],
	[ # 12
		"A bird in the hand is worth two in the bush", # title
		preload("res://assets/campaign/s2/a bird in the hand is worth two in the bush.png"), # picture
	],
	[ # 13
		"A blast from the past", # title
		preload("res://assets/campaign/s2/a blast from the past.png"), # picture
	],
	[ # 14
		"A day late and a dollar short", # title
		preload("res://assets/campaign/s2/a day late and a dollar short.png"), # picture
	],
	[ # 15
		"A dog's life", # title
		preload("res://assets/campaign/s2/a dog's life.png"), # picture
	],
	[ # 16
		"A drop in the bucket", # title
		preload("res://assets/campaign/s2/a drop in the bucket.png"), # picture
	],
	[ # 17
		"A face like a bulldog chewing on a wasp", # title
		preload("res://assets/campaign/s2/a face like a bulldog chewing on a wasp.png"), # picture
	],
	[ # 18
		"A face like a burst couch", # title
		preload("res://assets/campaign/s2/a face like a burst couch.png"), # picture
	],
	[ # 19
		"A face that would scare a dog out of a butcher shop", # title
		preload("res://assets/campaign/s2/a face that would scare a dog out of a butcher shop.png"), # picture
	],
# s3
]
