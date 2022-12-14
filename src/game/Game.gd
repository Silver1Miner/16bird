extends Control

signal back(result)
signal restart()
var training = true
var autowin_used = false
var seconds = 0
var minutes = 0
var moves = 0
export var par_moves = 100
export var par_time = 180
var coin_gain = 0
onready var tap_to_start = $GameView/BoardView/ColorRect
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
onready var coin_display = $Complete/CompleteView/Stats/Coins
onready var display_coin_gain = $Complete/CompleteView/Stats/Coins/CoinValue
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
	solve_display.text = str(UserData.instant_solvers)
	if training:
		tap_to_start.visible = true
		clock_view.visible = UserData.training_track_time
		moves_view.visible = UserData.training_track_moves
		solve.visible = UserData.training_instant_solver_allowed
		instant_solve.visible = UserData.training_instant_solver_allowed
		if UserData.current_training_image_folder == 0:
			set_training(Images.get_level(UserData.current_training_image_index))
		else:
			set_training(Images.get_gallery_image(UserData.current_training_image_index))
	else:
		tap_to_start.visible = false
		display_time_best_text.visible = false
		display_time_best.visible = false
		display_move_best_text.visible = false
		display_move_best.visible = false
		if UserData.current_level < 10:
			set_campaign_game(Images.training_levels[UserData.current_level])
		elif UserData.current_level < UserData.max_level:
			if Images.check_valid_level(UserData.current_level):
				set_campaign_game(Images.get_level(UserData.current_level))
			else:
				push_error("no campaign level available")
		else:
			randomize()
			var choice = int(rand_range(10, UserData.max_level-1))
			if Images.check_valid_level(choice):
				set_campaign_game(Images.get_level(choice))
			else:
				push_error("invalid campaign level selected")

func set_training(data: Array) -> void:
	# 0 title, 1 picture
	title_display.text = data[0]
	title_display_complete.text = data[0]
	board.update_background_texture(data[1])
	pic_complete.texture = data[1]

func set_campaign_game(data: Array) -> void:
	# 0 title, 1 picture, 2 array
	title_display.text = data[0]
	title_display_complete.text = data[0]
	board.update_background_texture(data[1])
	pic_complete.texture = data[1]
	set_game_board(data[2])

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
	moves = 0
	autowin_used = false
	clock_display.text = "00:00"
	move_display.text = "0"
	instant_solve.disabled = true
	Audio.play_sound("res://assets/audio/sounds/back_002.ogg")
	emit_signal("back", 0)

func _on_Restart_pressed():
	if training:
		tap_to_start.visible = false
		timer.start(1)
		seconds = 0
		minutes = 0
		moves = 0
		autowin_used = false
		clock_display.text = "00:00"
		move_display.text = "0"
		board.scramble_board()
		Audio.play_sound("res://assets/audio/sounds/back_002.ogg")
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
	coin_gain = 0
	autowin_used = false
	timer.start(1)
	tap_to_start.visible = false
	Audio.play_place()
	if training and UserData.training_instant_solver_allowed and UserData.instant_solvers > 0:
		instant_solve.disabled = false
	elif not training and UserData.instant_solvers > 0:
		instant_solve.disabled = false
	else:
		instant_solve.disabled = true

func _on_Board_game_won():
	Audio.play_sound("res://assets/audio/sounds/confirmation_004.ogg")
	timer.stop()
	instant_solve.disabled = true
	result_display_time.text = clock_display.text
	if training and UserData.training_track_time and not autowin_used:
		UserData.check_time(minutes, seconds)
		result_display_time_best.text = UserData.get_best_time()
		display_time_best_text.visible = !autowin_used
		display_time_best.visible = display_time_best_text.visible
	result_display_move.text = str(moves)
	if training and UserData.training_track_moves and not autowin_used:
		UserData.check_move(moves)
		result_display_move_best.text = UserData.get_best_move()
		display_move_best_text.visible = !autowin_used
		display_move_best.visible = display_move_best_text.visible
	print("game win detected")
	_anim.play("Victory")
	if not training:
		if UserData.current_level <= UserData.max_level:
			UserData.current_level = int(clamp(UserData.current_level+1, 0, UserData.max_level))
		#if not autowin_used:
		var time_xp = int(clamp((par_time - (minutes * 60 + seconds))/10, 1, 18))
		var move_xp = int(clamp((par_moves - moves)/10, 1, 18))
		coin_gain = time_xp + move_xp
		display_coin_gain.text = str(coin_gain)
		coin_display.visible = true
		#else:
		#	coin_gain = 0
		#	coin_display.visible = false
	else:
		coin_display.visible = false

func _on_InstantSolve_pressed():
	autowin_used = true
	if UserData.instant_solvers > 0:
		UserData.instant_solvers -= 1
		solve_display.text = str(UserData.instant_solvers)
	board.auto_win()

func _on_OK_pressed():
	if _anim.is_playing():
		return
	Audio.play_sound("res://assets/audio/sounds/confirmation_004.ogg")
	emit_signal("back", coin_gain)

func _on_Replay_pressed():
	if _anim.is_playing():
		return
	_on_Restart_pressed()
	_anim.play_backwards("Victory")

func _on_Settings_pressed():
	Audio.play_collide()
	audio_settings.visible = !audio_settings.visible
