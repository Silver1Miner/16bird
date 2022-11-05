extends Node2D

signal enemy_destroyed()
onready var obj_registry = get_node_or_null("../../WorldObjects")
export var hp = 80 setget _set_hp
export var speed = 80
export var max_hp = 100
export var weaknesses = []
export var resistances = []
export var Explosion: PackedScene = preload("res://src/world/effects/Explosion.tscn")

func _ready() -> void:
	add_to_group("enemy")
	$Gun/Timer.wait_time = 2.0
	$Gun/Timer.start()
	$Gun.target_group = "player"

func _set_hp(new_hp: int) -> void:
	hp = clamp(new_hp, 0, max_hp)
	if hp <= 0:
		if obj_registry:
			var explosion = Explosion.instance()
			explosion.damage = 0
			explosion.size_scale = 1
			explosion.global_position = global_position
			obj_registry.call_deferred("add_child", explosion)
		emit_signal("enemy_destroyed")
		queue_free()

func _physics_process(delta) -> void:
	position.x -= speed * delta

func take_damage(damage: int, damage_type: int) -> void:
	if global_position.x > 640:
		return
	var damage_amount = damage
	if damage_type in weaknesses:
		damage_amount *= 2
	elif damage_type in resistances:
		damage_type /= 2
	_set_hp(hp - damage_amount)
