extends Control

onready var solver1 = $ScrollContainer/Display/Solver/Solve1
onready var solver2 = $ScrollContainer/Display/Solver/Solve2
onready var solver3 = $ScrollContainer/Display/Solver/Solve3
export var FCT: PackedScene = preload("res://src/effects/FCT.tscn")
onready var confirm_panel = $Confirm
onready var confirm_label = $Confirm/Label
onready var _anim = $AnimationPlayer

var cost = 0
var count = 0
signal attempt_purchase_solver(cost, count)

func show_no_funds_warning(rect_pos: Vector2) -> void:
	var fct = FCT.instance()
	add_child(fct)
	fct.rect_position = rect_pos
	fct.show_value("Insufficient Funds!", Vector2(0,-8), 1, PI/2,false,Color(1,1,1),2)
	Audio.play_sound("res://assets/audio/sounds/back_002.ogg")

func _on_Solve1_pressed():
	if 30 > UserData.coins:
		show_no_funds_warning(solver1.get_global_rect().position + Vector2(0, -30))
		return
	Audio.play_sound("res://assets/audio/sounds/handle/chipsHandle1.ogg")
	confirm_label.text = "Buy 1 Instant Solver for 30 Coins?"
	cost = 30
	count = 1
	_anim.play("ConfirmUp")

func _on_Solve2_pressed():
	if 280 > UserData.coins:
		show_no_funds_warning(solver2.get_global_rect().position + Vector2(0, -30))
		return
	Audio.play_sound("res://assets/audio/sounds/handle/chipsHandle1.ogg")
	confirm_label.text = "Buy 10 Instant Solvers for 280 Coins?"
	cost = 280
	count = 10
	_anim.play("ConfirmUp")

func _on_Solve3_pressed():
	if 500 > UserData.coins:
		show_no_funds_warning(solver3.get_global_rect().position + Vector2(0, -30))
		return
	Audio.play_sound("res://assets/audio/sounds/handle/chipsHandle1.ogg")
	confirm_label.text = "Buy 20 Instant Solvers for 500 Coins?"
	cost = 500
	count = 20
	_anim.play("ConfirmUp")

func _on_Confirm_pressed():
	Audio.play_sound("res://assets/audio/sounds/handle/chipsHandle1.ogg")
	_anim.play_backwards("ConfirmUp")
	emit_signal("attempt_purchase_solver", cost, count)
	cost = 0
	count = 0

func _on_Cancel_pressed():
	Audio.play_sound("res://assets/audio/sounds/back_002.ogg")
	_anim.play_backwards("ConfirmUp")
	cost = 0
	count = 0
