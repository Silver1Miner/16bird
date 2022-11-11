extends Control

signal to_campaign()
signal to_freeplay()
signal open_settings()
signal quit()

func _ready():
	pass # Replace with function body.

func _on_Campaign_pressed():
	emit_signal("to_campaign")

func _on_FreePlay_pressed():
	emit_signal("to_freeplay")

func _on_Settings_pressed():
	emit_signal("open_settings")

func _on_Quit_pressed():
	emit_signal("quit")
