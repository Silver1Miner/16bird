extends Area2D

export var damage := 0.0
export var size_scale = 1
export var lifetime = 0.5
export var damage_type = 0
onready var timer = $Timer
onready var anim = $AnimatedSprite

func _ready() -> void:
	scale = Vector2(size_scale, size_scale)
	timer.wait_time = lifetime
	timer.start()
	anim.play("default")

func _on_Explosion_area_entered(area: Area2D) -> void:
	if damage > 0 and area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(damage, damage_type)

func _on_Timer_timeout() -> void:
	queue_free()
