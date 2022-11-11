extends Control

signal back()
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
onready var timer = $Timer

func _ready():
	pass # Replace with function body.

func get_ready() -> void:
	if training:
		clock.visible = Settings.training_track_time
		moves.visible = Settings.training_track_moves
		solve.visible = Settings.training_instant_solver_allowed
		instant_solve.visible = Settings.training_instant_solver_allowed
		solve_display.text = str(Settings.instant_solvers)
	instant_solve.disabled = true
	board.reset_board()
	board.game_state = 0

func _on_Back_pressed():
	timer.stop()
	seconds = 0
	minutes = 0
	clock_display.text = "00:00"
	move_display.text = "0"
	instant_solve.disabled = true
	emit_signal("back")

func _on_Restart_pressed():
	timer.start(1)
	seconds = 0
	minutes = 0
	clock_display.text = "00:00"
	move_display.text = "0"
	board.scramble_board()

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

func _on_InstantSolve_pressed():
	if Settings.instant_solvers > 0:
		Settings.instant_solvers -= 1
		solve_display.text = str(Settings.instant_solvers)
	board.auto_win()
