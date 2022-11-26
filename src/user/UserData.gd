extends Node

var training_track_time = true # setting
var training_track_moves = true # setting
var training_instant_solver_allowed = true # setting
var instant_solvers = 30 # progress
var coins = 100 # progress
var tokens = 10 # progress
var mute_sound = false # setting
var mute_music = false # setting
var current_level = 29 # progress
var max_level = 30 # GAME PARMETER
var best_time = 0 # progress
var best_move = 0 # progrees
var jukebox_index = 1 # setting
var current_training_image_folder = 0
var current_training_image_index = 0
var inventory = [ # progress
	0,1,9,4
]
var max_pictures = 10 # GAME PARAMETER

func check_time(minute: int, second: int) -> void:
	var total = minute * 60 + second
	if total < best_time or best_time == 0:
		best_time = total

func check_move(moves: int) -> void:
	if moves < best_move or best_move == 0:
		best_move = moves

func get_best_time() -> String:
	var minutes = int(best_time/60)
	var seconds = best_time % 60
	var minute_display = ""
	if minutes < 10:
		minute_display = "0" + str(minutes)
	else:
		minute_display = str(minutes)
	var second_display = ""
	if seconds < 10:
		second_display = "0" + str(int(seconds))
	else:
		second_display = str(int(seconds))
	if minute_display + second_display == "0000":
		return "--:--"
	return minute_display + ":" + second_display

func get_best_move() -> String:
	if best_move == 0:
		return "-"
	return str(best_move)

func load_data() -> void:
	print("attempting load data")

func save_data() -> void:
	print("attempting save")

func load_settings() -> void:
	print("attempting load settings")
	var settings = File.new()
	if not settings.file_exists("user://settings.save"):
		print("no settings file found")
		return
	settings.open("user://settings.save", File.READ)
	var settings_dict = parse_json(settings.get_line())
	if settings_dict != null:
		training_track_time = bool(settings_dict["training_track_time"])
		training_track_moves = bool(settings_dict["training_track_moves"])
		training_instant_solver_allowed = bool(settings_dict["training_instant_solver_allowed"])
		mute_sound = bool(settings_dict["mute_sound"])
		mute_music = bool(settings_dict["mute_music"])
		jukebox_index = int(settings_dict["jukebox_index"])
		print(settings_dict)
	settings.close()

func save_settings() -> void:
	print("attempting save settings")
	var settings = File.new()
	settings.open("user://settings.save", File.WRITE)
	var settings_dict = {
		"training_track_time": training_track_time,
		"training_track_moves": training_track_moves,
		"training_instant_solver_allowed": training_instant_solver_allowed,
		"mute_sound": mute_sound,
		"mute_music": mute_music,
		"jukebox_index": jukebox_index,
	}
	print(settings_dict)
	settings.store_line(to_json(settings_dict))
