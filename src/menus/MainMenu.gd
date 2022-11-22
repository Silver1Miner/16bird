extends Control

signal to_campaign()
signal to_freeplay()
signal quit()
var energy = 10 setget _set_energy
var coins = 0 setget _set_coins
var solvers = 0 setget _set_solvers
var seconds = 0
const SECONDS_TO_NEXT = 600
onready var tween = $Tween
onready var panels = $Panels
onready var select_bar = $HUD/SelectBar
onready var track_time_button = $Panels/Training/TrainOptions/Time/TrackTime
onready var track_moves_button = $Panels/Training/TrainOptions/Moves/TrackMoves
onready var allow_solvers_button = $Panels/Training/TrainOptions/Solver/AllowSolvers
onready var campaign_button = $Panels/Campaign/Campaign
onready var energy_display = $HUD/Panel/Energy/EnergyIcon/EnergyValue
onready var coins_display = $HUD/Panel/Coins/CoinValue
onready var solvers_display = $HUD/Panel/Solvers/SolversValue
onready var clock_display = $HUD/Panel/Energy/ClockDisplay
onready var clock = $Tick
onready var settings_menu = $HUD/Panel/SettingsMenu

func _ready():
	settings_menu.visible = false
	track_moves_button.pressed = Settings.training_track_moves
	track_time_button.pressed = Settings.training_track_time
	allow_solvers_button.pressed = Settings.training_instant_solver_allowed
	_set_solvers(Settings.instant_solvers)
	_set_coins(Settings.coins)
	panels.rect_position.x = 2 * -360
	update_display()

func update_display() -> void:
	_set_solvers(Settings.instant_solvers)
	_set_coins(Settings.coins)
	if Images.check_valid_level(Settings.current_level):
		campaign_button.text = "LEVEL " + str(Settings.current_level + 1)
		campaign_button.disabled = false
	else:
		campaign_button.disabled = true
		campaign_button.text = "CAMPAIGN COMPLETE!"

func handle_coin_gain(coin_gain: int) -> void:
	if coin_gain == 0:
		return
	else:
		_set_coins(coins + coin_gain)
		print("coin gain: ", coin_gain)

func _on_SelectBar_selected(current_select):
	if tween:
		settings_menu.visible = false
		tween.interpolate_property(self, "rect_position:x",
		rect_position.x, (current_select - 2) * -360, 0.3,
		Tween.TRANS_QUART, Tween.EASE_IN_OUT)
		tween.start()
	$Panels/GalleryMenu.update_all()

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
	settings_menu.visible = false
	select_bar.get_node("ToShop").pressed = true

func _on_CoinIcon_pressed():
	settings_menu.visible = false
	select_bar.get_node("ToShop").pressed = true

func _set_energy(new_value: int) -> void:
	energy = new_value
	energy_display.text = str(energy)

func _set_coins(new_value: int) -> void:
	coins = int(clamp(new_value, 0, 99999999))
	coins_display.text = str(coins)
	Settings.coins = coins

func _set_solvers(new_value: int) -> void:
	solvers = int(clamp(new_value, 0, 99999999))
	solvers_display.text = str(solvers)
	Settings.instant_solvers = solvers

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

func _on_SettingsButton_pressed():
	settings_menu.visible = !settings_menu.visible

func _on_StoreMenu_attempt_purchase_solver(cost: int, count: int):
	if cost > coins:
		print("not enough coins!")
		return
	_set_coins(coins - cost)
	_set_solvers(solvers + count)
	
