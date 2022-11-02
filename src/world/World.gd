extends Node2D

onready var timer = $Timer
onready var spawns = $SpawnPoints
onready var player = $Player
onready var obs = $WorldObjects
var ready = false
var started = false

func _ready():
	player.active = true
