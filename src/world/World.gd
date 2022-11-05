extends Node2D

onready var timer = $Timer
onready var player = $WorldObjects/Player
onready var obs = $WorldObjects
var ready = false
var started = false
var rng = RandomNumberGenerator.new()

func _ready():
	player.active = true
