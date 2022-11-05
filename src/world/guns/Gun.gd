extends Position2D

export var Bullet = preload("res://src/world/bullets/Bullet.tscn")
export var wait_time = 1.0
export var bullet_count = 1
export var angle = 90
export var velocity := Vector2(400, 0)
export var target_group = "player"
onready var timer = $Timer

func _ready():
	timer.wait_time = wait_time

func _on_Timer_timeout():
	if global_position.x < 640 and get_parent().get_parent():
		var bullet_instance = Bullet.instance()
		get_parent().get_parent().call_deferred("add_child", bullet_instance)
		bullet_instance.target_group = target_group
		bullet_instance.global_position = global_position
		bullet_instance.rotation_degrees = angle
		bullet_instance.velocity = velocity
		if bullet_count > 1:
			var bullet_instance_1 = Bullet.instance()
			var bullet_instance_2 = Bullet.instance()
			get_parent().get_parent().call_deferred("add_child", bullet_instance_1)
			get_parent().get_parent().call_deferred("add_child", bullet_instance_2)
			bullet_instance_1.target_group = target_group
			bullet_instance_2.target_group = target_group
			bullet_instance_1.global_position = global_position
			bullet_instance_2.global_position = global_position
			bullet_instance_1.velocity = velocity.rotated(deg2rad(5))
			bullet_instance_2.velocity = velocity.rotated(deg2rad(-5))
			bullet_instance_1.rotation_degrees = angle + 5
			bullet_instance_2.rotation_degrees = angle - 5
