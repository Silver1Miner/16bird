extends Control

signal game_over_acknowledged()

func _ready():
	$GameOver.visible = false

func game_over(counter: int, max_counter: int) -> void:
	$GameOver.visible = true
	$GameOver/ScoreRecord.text = "Score: " + str(counter) + "\n" + "Record: " + str(max_counter)

func _on_Accept_pressed():
	$GameOver.visible = false
	emit_signal("game_over_acknowledged")
