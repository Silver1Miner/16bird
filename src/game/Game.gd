extends Control

signal back()
signal restart()
signal replay()
signal next()
var training = true
var seconds = 0
var minutes = 0
onready var board = $GameView/BoardView/Board
onready var clock = $GameView/Status/Clock
onready var moves = $GameView/Status/Moves
onready var solve = $GameView/Status/Solvers
onready var clock_display = $GameView/Status/Clock/Clock
onready var move_display = $GameView/Status/Moves/MoveValue
onready var solve_display = $GameView/Status/Solvers/SolveValue
onready var instant_solve = $GameView/Status/InstantSolve
onready var _anim = $AnimationPlayer
onready var timer = $Timer
onready var title_display = $GameView/Commands/Title
onready var title_display_complete = $Complete/CompleteView/Title
onready var pic_complete = $Complete/CompleteView/Picture

func _ready():
	pass # Replace with function body.

func get_ready() -> void:
	_anim.play("RESET")
	if training:
		clock.visible = Settings.training_track_time
		moves.visible = Settings.training_track_moves
		solve.visible = Settings.training_instant_solver_allowed
		instant_solve.visible = Settings.training_instant_solver_allowed
		solve_display.text = str(Settings.instant_solvers)
	instant_solve.disabled = true
	board.reset_board()
	board.game_state = 0

func set_game_data(data: Array) -> void:
	# 0 array, 1 title, 2 picture
	title_display.text = data[1]
	title_display_complete.text = data[1]
	board.update_background_texture(data[2])
	pic_complete.texture = data[2]
	set_game_board(data[0])

func set_game_board(custom_flat: Array) -> void:
	board.set_custom_board(custom_flat)
	board.game_state = 1
	seconds = 0
	minutes = 0
	clock_display.text = "00:00"
	move_display.text = "0"
	timer.start(1)

func _on_Back_pressed():
	timer.stop()
	seconds = 0
	minutes = 0
	clock_display.text = "00:00"
	move_display.text = "0"
	instant_solve.disabled = true
	emit_signal("back")

func _on_Restart_pressed():
	if training:
		timer.start(1)
		seconds = 0
		minutes = 0
		clock_display.text = "00:00"
		move_display.text = "0"
		board.scramble_board()
	else:
		emit_signal("restart")

func _on_Settings_pressed():
	pass # Replace with function body.

func _on_Timer_timeout():
	seconds += 1
	if seconds < 0:
		seconds = 1
	elif seconds >= 60:
		minutes += 1
		seconds = 0
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
	clock_display.text = minute_display + ":" + second_display

func _on_Board_moves_updated(move_count: int):
	move_display.text = str(move_count)

func _on_Board_game_started():
	seconds = 0
	minutes = 0
	timer.start()
	if Settings.training_instant_solver_allowed and Settings.instant_solvers > 0:
		instant_solve.disabled = false

func _on_Board_game_won():
	timer.stop()
	print("game win detected")
	_anim.play("Victory")
	if not training:
		Settings.current_level += 1

func _on_InstantSolve_pressed():
	if Settings.instant_solvers > 0:
		Settings.instant_solvers -= 1
		solve_display.text = str(Settings.instant_solvers)
	board.auto_win()

func _on_Mute_toggled(button_pressed):
	Settings.mute = button_pressed

func _on_OK_pressed():
	if _anim.is_playing():
		return
	emit_signal("back")

func _on_Replay_pressed():
	if _anim.is_playing():
		return
	emit_signal("replay")
	_anim.play_backwards("Victory")

func _on_Next_pressed():
	if _anim.is_playing():
		return
	emit_signal("next")
