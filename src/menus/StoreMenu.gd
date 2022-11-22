extends Control

onready var solver1 = $ScrollContainer/Display/Solver/Solve1
onready var solver2 = $ScrollContainer/Display/Solver/Solve2
onready var solver3 = $ScrollContainer/Display/Solver/Solve3
export var FCT: PackedScene = preload("res://src/effects/FCT.tscn")

signal attempt_purchase_solver(cost, count)

func show_no_funds_warning(rect_pos: Vector2) -> void:
	var fct = FCT.instance()
	add_child(fct)
	fct.rect_position = rect_pos
	fct.show_value("Insufficient Funds!", Vector2(0,-8), 1, PI/2,false,Color(1,1,1),2)

func _on_Solve1_pressed():
	if 30 > Settings.coins:
		show_no_funds_warning(solver1.get_global_rect().position + Vector2(0, -30))
		return
	emit_signal("attempt_purchase_solver", 30, 1)

func _on_Solve2_pressed():
	if 280 > Settings.coins:
		show_no_funds_warning(solver2.get_global_rect().position + Vector2(0, -30))
		return
	emit_signal("attempt_purchase_solver", 280, 10)

func _on_Solve3_pressed():
	if 500 > Settings.coins:
		show_no_funds_warning(solver3.get_global_rect().position + Vector2(0, -30))
		return
	emit_signal("attempt_purchase_solver", 500, 20)
