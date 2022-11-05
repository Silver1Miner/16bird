extends Node2D

onready var spawn_timer = $Timer
onready var player = $WorldObjects/Player
onready var obs = $WorldObjects
onready var enemy_formation = $EnemyLevel
onready var spawns = $SpawnPoints
var ready = false
var started = false
var rng = RandomNumberGenerator.new()
var enemy = preload("res://src/world/enemy/Enemy.tscn")
var counter = 0

func _ready():
	deactivate()

func _on_Timer_timeout():
	rng.randomize()
	var pos1 = rng.randi_range(0, 2)
	var drop1 = enemy.instance()
	if drop1.connect("enemy_destroyed", self, "_on_enemy_destroyed") != OK:
		push_error("signal failed to connect")
	drop1.global_position = spawns.get_children()[pos1].global_position
	enemy_formation.add_child(drop1)
	spawn_timer.wait_time = 3.0

func activate() -> void:
	if ready and not started:
		started = true
		player.activate()
		spawn_timer.start()
		$HUD/Instructions.visible = false

func deactivate() -> void:
	counter = 0
	$HUD/Score/Score.text = str(counter)
	ready = true
	started = false
	for n in $EnemyLevel.get_children():
		$EnemyLevel.remove_child(n)
		n.queue_free()
	player.respawn()
	$HUD/Instructions.visible = true
	spawn_timer.stop()
	spawn_timer.wait_time = 2.0

func _on_Player_player_action():
	if not started:
		print("game start!")
		activate()

func _on_Player_player_destroyed():
	$HUD.game_over()

func _on_HUD_game_over_acknowledged():
	deactivate()

func _on_enemy_destroyed() -> void:
	counter += 1
	$HUD/Score/Score.text = str(counter)

func _on_Player_hp_changed(hp):
	$HUD/HP/HP.text = str(hp)
