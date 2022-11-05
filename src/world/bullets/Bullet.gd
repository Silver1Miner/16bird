extends Area2D

onready var obj_registry = get_parent()
export var velocity = Vector2(400, 0)
export var damage = 10
export var damage_type = 0
export var piercing = false
export var explosive = false
export var Explosion: PackedScene = preload("res://src/world/effects/Explosion.tscn")
var target_group = "player"

func _ready():
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	position += velocity * delta
	if position.x < -40 or position.x > 1280 + 40:
		queue_free()

func _on_Bullet_area_entered(area):
	if damage > 0 and area.get_parent().is_in_group(target_group) and area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(damage, damage_type)
		if not piercing:
			queue_free()
			var explosion = Explosion.instance()
			if explosive:
				explosion.damage = damage
				explosion.size_scale = 1
			else:
				explosion.damage = 0
				explosion.size_scale = 0.5
			explosion.damage_type = 1
			explosion.global_position = global_position
			if obj_registry:
				obj_registry.call_deferred("add_child", explosion)
			queue_free()
