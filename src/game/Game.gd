extends Control

signal back()
signal restart()
var training = true
var autowin_used = false
var seconds = 0
var minutes = 0
var moves = 0
onready var restart_button = $GameView/Commands/Restart
onready var board = $GameView/BoardView/Board
onready var clock_view = $GameView/Status/Clock
onready var moves_view = $GameView/Status/Moves
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
onready var replay_button = $Complete/CompleteOptions/Replay
onready var result_display_time = $Complete/CompleteView/Stats/Time/TimeValue
onready var result_display_time_best = $Complete/CompleteView/Stats/Time/BestValue
onready var result_display_move = $Complete/CompleteView/Stats/Move/MoveValue
onready var result_display_move_best = $Complete/CompleteView/Stats/Move/BestValue
onready var display_time_best_text = $Complete/CompleteView/Stats/Time/BestText
onready var display_time_best = $Complete/CompleteView/Stats/Time/BestValue
onready var display_move_best_text = $Complete/CompleteView/Stats/Move/BestMove
onready var display_move_best = $Complete/CompleteView/Stats/Move/BestValue
onready var audio_settings = $AudioSettings

func get_ready() -> void:
	audio_settings.visible = false
	_anim.play("RESET")
	instant_solve.disabled = true
	autowin_used = false
	board.reset_board()
	board.game_state = 0
	replay_button.visible = training
	restart_button.visible = training
	if training:
		clock_view.visible = Settings.training_track_time
		moves_view.visible = Settings.training_track_moves
		solve.visible = Settings.training_instant_solver_allowed
		instant_solve.visible = Settings.training_instant_solver_allowed
		solve_display.text = str(Settings.instant_solvers)
		board.update_background_texture(Settings.current_training_background)
		pic_complete.texture = Settings.current_training_background
	else:
		display_time_best_text.visible = false
		display_time_best.visible = false
		display_move_best_text.visible = false
		display_move_best.visible = false
		if Settings.current_level < 10:
			set_campaign_game(Campaign.training_levels[Settings.current_level])
		else:
			if Campaign.check_valid_level(Settings.current_level):
				set_campaign_game(Campaign.get_level(Settings.current_level))
			else:
				push_error("no campaign level available")

func set_campaign_game(data: Array) -> void:
	# 0 array, 1 title, 2 picture
	title_display.text = data[1]
	title_display_complete.text = data[1]
	board.update_background_texture(data[2])
	pic_complete.texture = data[2]
	set_game_board(data[0])

func set_game_board(custom_flat: Array) -> void:
	if len(custom_flat) == 0:
		board.scramble_board()
	else:
		board.set_custom_board(custom_flat)
	board.game_state = 1
	seconds = 0
	minutes = 0
	moves = 0
	clock_display.text = "00:00"
	move_display.text = "0"
	_on_Board_game_started()

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
		moves = 0
		clock_display.text = "00:00"
		move_display.text = "0"
		board.scramble_board()
	else:
		push_error("cannot restart campaign mission")
		emit_signal("restart")

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
	moves = move_count
	move_display.text = str(moves)

func _on_Board_game_started():
	seconds = 0
	minutes = 0
	moves = 0
	autowin_used = false
	timer.start(1)
	if Settings.training_instant_solver_allowed and Settings.instant_solvers > 0:
		instant_solve.disabled = false

func _on_Board_game_won():
	timer.stop()
	result_display_time.text = clock_display.text
	if training and Settings.training_track_time:
		Settings.check_time(minutes, seconds)
		result_display_time_best.text = Settings.get_best_time()
		display_time_best_text.visible = !autowin_used
		display_time_best.visible = display_time_best_text.visible
	result_display_move.text = str(moves)
	if training and Settings.training_track_moves:
		Settings.check_move(moves)
		result_display_move_best.text = Settings.get_best_move()
		display_move_best_text.visible = !autowin_used
		display_move_best.visible = display_move_best_text.visible
	print("game win detected")
	_anim.play("Victory")
	if not training:
		Settings.current_level += 1

func _on_InstantSolve_pressed():
	autowin_used = true
	if Settings.instant_solvers > 0:
		Settings.instant_solvers -= 1
		solve_display.text = str(Settings.instant_solvers)
	board.auto_win()

func _on_OK_pressed():
	if _anim.is_playing():
		return
	emit_signal("back")

func _on_Replay_pressed():
	if _anim.is_playing():
		return
	_on_Restart_pressed()
	_anim.play_backwards("Victory")

func _on_Settings_pressed():
	audio_settings.visible = !audio_settings.visible
