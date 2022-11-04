extends Node2D

signal fire()
signal hp_changed(hp)

var vel = Vector2()
export var gravity = 100
export var jump_force = 120
onready var tween = $Tween
onready var timer = $Timer
onready var hp_bar = $TextureProgress
export var weaknesses = []
export var resistances = []
var active = false
var slide := 30
onready var obj_registry = get_parent()
export var hp := 100 setget _set_hp
var max_hp = 100
export var Explosion: PackedScene = preload("res://src/World/Effects/Explosion.tscn")

func _ready() -> void:
	_set_hp(hp)

func _physics_process(delta) -> void:
	if not active:
		return
	vel.y += gravity * delta
	#if Input.is_action_just_pressed("ui_accept"):
	#	vel.y -= jump_force
	position.y = clamp(position.y, 0, 720)
	position += vel * delta

func _unhandled_input(event) -> void:
	if not active:
		return
	if event is InputEventScreenDrag:
		var swipe = event.relative
		if swipe.x > slide:
			print("swipe right")
			if timer.is_stopped():
				emit_signal("fire")
				timer.start(0.2)
	elif event is InputEventScreenTouch:
		var touch = event.position
		if touch.x < 0 or touch.x > 1280:
			return
		vel.y -= jump_force
	if event.is_action_pressed("ui_up"):
		vel.y -= jump_force
	elif event.is_action_pressed("ui_accept"):
		vel.y -= jump_force


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
		queue_free()

func take_damage(damage: int, damage_type: int) -> void:
	var damage_amount = damage
	if damage_type in weaknesses:
		damage_amount *= 2
	elif damage_type in resistances:
		damage_type /= 2
	_set_hp(hp - damage_amount)

func _on_Hitbox_area_entered(area):
	if not active:
		return
	var id = -1
	if area.has_method("get_id"):
		id = area.get_id()
	if area.get_parent() and area.get_parent().has_method("_set_hp"):
		take_damage(area.get_parent().hp, 0)
	print("collided with: ", id)
