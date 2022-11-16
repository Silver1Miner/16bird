extends Control

func _on_MainMenu_to_freeplay():
	print("to free play")
	$Game.training = true
	$MainMenu.visible = false
	$MainMenu/HUD.visible = false
	$Game.get_ready()
	$Game.visible = true

func _on_MainMenu_to_campaign():
	print("to campaign")
	$Game.training = false
	$MainMenu.visible = false
	$MainMenu/HUD.visible = false
	$Game.get_ready()
	$Game.visible = true

func _on_MainMenu_quit():
	get_tree().quit()

func _on_Game_back():
	$MainMenu.update_display()
	$MainMenu.visible = true
	$MainMenu/HUD.visible = true
	$Game.visible = false
