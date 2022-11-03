extends Node2D

onready var timer = $Timer
onready var spawns = $SpawnPoints
onready var player = $Player
onready var obs = $WorldObjects
var ready = false
var started = false
export var block = preload("res://src/world/blocks/Block.tscn")

func _ready():
	player.active = true

func _on_Timer_timeout():
	pass # Replace with function body.
