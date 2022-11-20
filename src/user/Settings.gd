extends Node

var training_track_time = true
var training_track_moves = true
var training_instant_solver_allowed = true
var instant_solvers = 30
var mute_sound = false
var mute_music = false
var current_level = 10
var best_time = 0
var best_move = 0
var current_training_image_index = 0
var gallery_owned = [
	0,1,4,9,
]


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
