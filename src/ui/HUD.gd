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

func activate_text() -> void:
	$TextPanel.visible = true

func _on_Left_pressed():
	$TextPanel.visible = false

func _on_Right_pressed():
	$TextPanel.visible = false
