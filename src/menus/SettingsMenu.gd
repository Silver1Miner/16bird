extends TextureRect

signal clear_data()

onready var confirm_delete_button = $Delete/ConfirmDelete
onready var set_delete_button = $Delete/SetDelete

func _ready():
	confirm_delete_button.disabled = true

func _on_SetDelete_toggled(button_pressed: bool):
	confirm_delete_button.disabled = !button_pressed

func _on_ConfirmDelete_pressed():
	set_delete_button.pressed = false
	emit_signal("clear_data")

func _on_Close_pressed():
	visible = false
