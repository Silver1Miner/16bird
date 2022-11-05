extends Position2D

onready var obj_registry = get_node_or_null("../../../WorldObjects")
export var Bullet = preload("res://src/world/bullets/Bullet.tscn")
export var wait_time = 0.8
export var angle = 90
export var velocity = 400
onready var timer = $Timer

func _ready():
	timer.wait_time = wait_time
	timer.start()

func _on_Timer_timeout():
	if global_position.x < 1280 and obj_registry:
		var bullet_instance = Bullet.instance()
		obj_registry.call_deferred("add_child", bullet_instance)
		bullet_instance.global_position = global_position
		bullet_instance.rotation_degrees = angle
		bullet_instance.speed = velocity
