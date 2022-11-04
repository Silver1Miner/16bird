extends Node2D

onready var timer = $Timer
onready var player = $Player
onready var obs = $WorldObjects
var ready = false
var started = false
export var block = preload("res://src/world/blocks/Block.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	player.active = true
