extends Node2D

signal player_action()
signal player_destroyed()
signal hp_changed(hp)

const TOP = 90
const MID = 180
const BOT = 270
enum lane {TOP, MID, BOT}
var current_lane = lane.MID
onready var tween = $Tween
onready var timer = $Timer
onready var hp_bar = $TextureProgress
onready var particle = $CPUParticles2D
var active = false
var slide := 30
onready var obj_registry = get_parent()
export var hp := 5 setget _set_hp
var max_hp = 5
export var Explosion: PackedScene = preload("res://src/world/effects/Explosion.tscn")

func _ready() -> void:
	add_to_group("player")
	_set_hp(hp)

func change_lane(new_lane) -> void:
	current_lane = new_lane
	match current_lane:
		lane.TOP:
			tween.interpolate_property(self, "global_position:y", global_position.y, TOP, 0.05,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.start()
		lane.MID:
			tween.interpolate_property(self, "global_position:y", global_position.y, MID, 0.05,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.start()
		lane.BOT:
			tween.interpolate_property(self, "global_position:y", global_position.y, BOT, 0.05,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.start()

func activate() -> void:
	active = true

func _unhandled_input(event) -> void:
	if event is InputEventScreenDrag:
		var swipe = event.relative
		if swipe.y > slide:
			print("swipe up")
			if current_lane > 0:
				change_lane(current_lane - 1)
			emit_signal("player_action")
		elif swipe.y < -slide:
			print("swipe down")
			if current_lane < 2:
				change_lane(current_lane + 1)
			emit_signal("player_action")
	elif event is InputEventScreenTouch:
		print("touch")
		var touch = event.position
		if touch.x < 0 or touch.x > 1280 or touch.y < 0 or touch.y > 720:
			return
		if touch.y <= TOP + 60:
			change_lane(0)
		elif touch.y >= BOT - 60:
			change_lane(2)
		else:
			change_lane(1)
		emit_signal("player_action")
	if event.is_action_pressed("ui_up"):
		print("up")
		if current_lane > 0:
			change_lane(current_lane - 1)
		emit_signal("player_action")
	elif event.is_action_pressed("ui_down"):
		print("down")
		if current_lane < 2:
			change_lane(current_lane + 1)
		emit_signal("player_action")
	elif event.is_action_pressed("ui_accept"):
		print("space")
		emit_signal("player_action")


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
		set_physics_process(false)

func respawn() -> void:
	_set_hp(max_hp)
	$Hitbox/CollisionShape2D.set_deferred("disabled", false)
	global_position.y = 180
	visible = true

func take_damage(damage: int) -> void:
	if hp <= 0:
		return
	_set_hp(hp - damage)

func _on_Hitbox_area_entered(area):
	if not active:
		return
	if area.get_parent() and area.get_parent().has_method("_set_hp"):
		take_damage(area.get_parent().hp)
