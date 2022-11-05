extends Control

signal game_over_acknowledged()

func _ready():
	$GameOver.visible = false

func game_over() -> void:
	$GameOver.visible = true

func _on_Accept_pressed():
	$GameOver.visible = false
	emit_signal("game_over_acknowledged")
