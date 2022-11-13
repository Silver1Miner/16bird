extends Control

signal to_campaign()
signal to_freeplay()
signal quit()
var energy = 10 setget _set_energy
var coins = 0 setget _set_coins
var seconds = 0
const SECONDS_TO_NEXT = 600
var campaign = preload("res://data/campaign.tres")
onready var tween = $Tween
onready var panels = $Panels
onready var select_bar = $HUD/SelectBar
onready var track_time_button = $Panels/Training/TrainOptions/Time/TrackTime
onready var track_moves_button = $Panels/Training/TrainOptions/Moves/TrackMoves
onready var allow_solvers_button = $Panels/Training/TrainOptions/Solver/AllowSolvers
onready var campaign_button = $Panels/Campaign/Campaign
onready var energy_display = $HUD/Panel/Energy/EnergyIcon/EnergyValue
onready var coins_display = $HUD/Panel/Coins/CoinValue
onready var clock_display = $HUD/Panel/Energy/ClockDisplay
onready var clock = $Tick

func _ready():
	track_moves_button.pressed = Settings.training_track_moves
	track_time_button.pressed = Settings.training_track_time
	allow_solvers_button.pressed = Settings.training_instant_solver_allowed
	panels.rect_position.x = 2 * -360
	update_display()

func update_display() -> void:
	if Settings.current_level >= len(campaign.levels):
		campaign_button.text = "RANDOM"
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

func _on_EnergyIcon_pressed():
	select_bar.get_node("ToShop").pressed = true

func _on_CoinIcon_pressed():
	select_bar.get_node("ToShop").pressed = true

func _set_energy(new_value: int) -> void:
	energy = new_value
	energy_display.text = str(energy)

func _set_coins(new_value: int) -> void:
	coins = new_value
	coins_display.text = str(coins)

func _on_Tick_timeout():
	if seconds <= 0:
		seconds = 0
		if energy < 5:
			_set_energy(energy+1)
			if energy >= 5:
				_set_energy(5)
				clock.stop()
			else:
				seconds = SECONDS_TO_NEXT
