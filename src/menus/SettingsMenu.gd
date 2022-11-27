extends TextureRect

signal clear_data()

onready var confirm_delete_button = $Delete/ConfirmDelete
onready var set_delete_button = $Delete/SetDelete
onready var credits_page = $Credits

func _ready():
	confirm_delete_button.disabled = true
	credits_page.visible = false

func _on_SetDelete_toggled(button_pressed: bool):
	confirm_delete_button.disabled = !button_pressed
	Audio.play_collide()

func _on_ConfirmDelete_pressed():
	set_delete_button.pressed = false
	Audio.play_collide()
	emit_signal("clear_data")

func _on_Close_pressed():
	UserData.save_settings()
	Audio.play_collide()
	visible = false

func _on_ViewCredits_pressed():
	credits_page.visible = true
	Audio.play_collide()

func _on_CloseCredits_pressed():
	credits_page.visible = false
	Audio.play_collide()

