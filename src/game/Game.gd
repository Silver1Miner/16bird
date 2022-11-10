extends Control

var seconds = 0
onready var clock_display = $GameView/Status/Clock/Clock
onready var move_display = $GameView/Status/Moves/MoveValue

func _ready():
	pass # Replace with function body.

func _on_Back_pressed():
	pass # Replace with function body.

func _on_Restart_pressed():
	pass # Replace with function body.

func _on_Settings_pressed():
	pass # Replace with function body.

func _on_Timer_timeout():
	seconds += 1

func _on_Board_moves_updated(move_count: int):
	move_display.text = str(move_count)

func _on_Board_game_started():
	pass # Replace with function body.

func _on_Board_game_won():
	pass # Replace with function body.
