extends Node2D

signal player_action()
signal player_destroyed()
signal fire()
signal hp_changed(hp)

var vel = Vector2()
export var gravity = 100
export var jump_force = 120
onready var tween = $Tween
onready var timer = $Timer
onready var hp_bar = $TextureProgress
onready var particle = $CPUParticles2D
export var weaknesses = []
export var resistances = []
var active = false
var slide := 30
onready var obj_registry = get_parent()
export var hp := 100 setget _set_hp
var max_hp = 100
export var Explosion: PackedScene = preload("res://src/world/effects/Explosion.tscn")

func _ready() -> void:
	add_to_group("player")
	$Gun.target_group = "enemy"
	$Gun.bullet_count = 2
	$Gun/Timer.wait_time = 0.1
	$Gun.velocity = Vector2(800, 0)
	_set_hp(hp)
	set_physics_process(false)

func activate() -> void:
	active = true
	$Gun/Timer.start()
	set_physics_process(true)

func _physics_process(delta) -> void:
	vel.y += clamp(gravity * delta, -120, 120)
	#if Input.is_action_just_pressed("ui_accept"):
	#	vel.y -= jump_force
	position.y = clamp(position.y, 1, 360)
	position += vel * delta
	if position.y <= 40:
		vel.y = jump_force
		if obj_registry:
			var explosion = Explosion.instance()
			explosion.damage = 0
			explosion.size_scale = 0.5
			explosion.global_position = global_position
			obj_registry.call_deferred("add_child", explosion)
	if position.y >= 320:
		vel.y = -jump_force
		if obj_registry:
			var explosion = Explosion.instance()
			explosion.damage = 0
			explosion.size_scale = 0.5
			explosion.global_position = global_position
			obj_registry.call_deferred("add_child", explosion)

func _unhandled_input(event) -> void:
	if event is InputEventScreenDrag:
		var swipe = event.relative
		if swipe.x > slide:
			print("swipe right")
			if timer.is_stopped():
				emit_signal("fire")
				timer.start(0.2)
			emit_signal("player_action")
	elif event is InputEventScreenTouch:
		print("touch")
		var touch = event.position
		if touch.x < 0 or touch.x > 1280:
			return
		vel.y -= jump_force
		emit_signal("player_action")
		particle.emitting = true
	if event.is_action_pressed("ui_up"):
		print("up")
		vel.y -= jump_force
		emit_signal("player_action")
		particle.emitting = true
	elif event.is_action_pressed("ui_accept"):
		print("space")
		vel.y -= jump_force
		emit_signal("player_action")
		particle.emitting = true

func _set_hp(new_hp: int) -> void:
	if hp != new_hp:
		hp = int(clamp(new_hp, 0, max_hp))
		emit_signal("hp_changed", hp)
	hp_bar.value = hp
	if hp <= 0:
		if obj_registry:
			var explosion = Explosion.instance()
			explosion.damage = 0
			explosion.size_scale = 0.5
			explosion.global_position = global_position
			obj_registry.call_deferred("add_child", explosion)
		emit_signal("player_destroyed")
		visible = false
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$Gun/Timer.stop()
		set_physics_process(false)

func respawn() -> void:
	_set_hp(max_hp)
	$Hitbox/CollisionShape2D.set_deferred("disabled", false)
	global_position.y = 180
	set_physics_process(false)
	vel.y = 0
	visible = true

func take_damage(damage: int, damage_type: int) -> void:
	if hp <= 0:
		return
	var damage_amount = damage
	if damage_type in weaknesses:
		damage_amount *= 2
	elif damage_type in resistances:
		damage_type /= 2
	_set_hp(hp - damage_amount)

func _on_Hitbox_area_entered(area):
	if not active:
		return
	if area.get_parent() and area.get_parent().has_method("_set_hp"):
		take_damage(area.get_parent().hp, 0)
