extends Node2D

onready var timer = $Timer
onready var spawns = $SpawnPoints
onready var player = $Player
onready var obs = $WorldObjects
var ready = false
var started = false
export var block = preload("res://src/world/blocks/Block.tscn")
var rng = RandomNumberGenerator.new()
export var PACE = 1.0

func _ready():
	player.active = true

var can_have_block = true
func _on_Timer_timeout():
	rng.randomize()
	if can_have_block:
		can_have_block = false
		var pos1 = rng.randi_range(0, 2)
		var pos2 = pos1 + 1
		if pos2 > 2:
			pos2 = 0
		var drop1 = block.instance()
		var drop2 = block.instance()
		drop1.global_position = spawns.get_children()[pos1].global_position
		drop2.global_position = spawns.get_children()[pos2].global_position
		obs.add_child(drop1)
		obs.add_child(drop2)
	else:
		can_have_block = true
	timer.wait_time = PACE
	timer.start()
