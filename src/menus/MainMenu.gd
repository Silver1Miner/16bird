extends Control

signal to_campaign()
signal to_freeplay()
signal quit()
var campaign = preload("res://data/campaign.tres")
onready var tween = $Tween
onready var panels = $Panels
onready var track_time_button = $Panels/Training/TrainOptions/Time/TrackTime
onready var track_moves_button = $Panels/Training/TrainOptions/Moves/TrackMoves
onready var allow_solvers_button = $Panels/Training/TrainOptions/Solver/AllowSolvers
onready var campaign_button = $Panels/Campaign/Campaign

func _ready():
	track_moves_button.pressed = Settings.training_track_moves
	track_time_button.pressed = Settings.training_track_time
	allow_solvers_button.pressed = Settings.training_instant_solver_allowed
	panels.rect_position.x = 2 * -360
	update_display()

func update_display() -> void:
	if Settings.current_level >= len(campaign.levels):
		campaign_button.text = "TRAINING"
	else:
		campaign_button.text = "LEVEL " + str(Settings.current_level + 1)

func _on_SelectBar_selected(current_select):
	if tween:
		tween.interpolate_property(self, "rect_position:x",
		rect_position.x, (current_select - 2) * -360, 0.3,
		Tween.TRANS_QUART, Tween.EASE_IN_OUT)
		tween.start()

func _on_Campaign_pressed():
	emit_signal("to_campaign")

func _on_FreePlay_pressed():
	emit_signal("to_freeplay")

func _on_Quit_pressed():
	emit_signal("quit")

func _on_TrackMoves_toggled(button_pressed):
	Settings.training_track_moves = button_pressed

func _on_TrackTime_toggled(button_pressed):
	Settings.training_track_time = button_pressed

func _on_AllowSolvers_toggled(button_pressed):
	Settings.training_instant_solver_allowed = button_pressed
