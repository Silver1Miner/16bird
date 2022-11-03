extends Node2D

onready var obj_registry = get_parent()
export var hp = 50 setget _set_hp
export var max_hp = 50
export var weaknesses = []
export var resistances = []
export var Explosion: PackedScene = preload("res://src/World/Effects/Explosion.tscn")

func _ready():
	pass # Replace with function body.

func _set_hp(new_hp: int) -> void:
	hp = clamp(new_hp, 0, max_hp)
	if hp <= 0:
		if obj_registry:
			var explosion = Explosion.instance()
			explosion.damage = 0
			explosion.size_scale = 0.5
			explosion.global_position = global_position
			obj_registry.call_deferred("add_child", explosion)
		queue_free()

func take_damage(damage: int, damage_type: int) -> void:
	var damage_amount = damage
	if damage_type in weaknesses:
		damage_amount *= 2
	elif damage_type in resistances:
		damage_type /= 2
	_set_hp(hp - damage_amount)
