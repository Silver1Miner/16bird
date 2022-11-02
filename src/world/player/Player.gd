extends Node2D

signal fire()

enum LANE {LEFT, CENTER, RIGHT}
const x_left = 180
const x_center = 360
const x_right = 540
var current_lane = LANE.CENTER
onready var tween = $Tween
onready var timer = $Timer
var active = false
var slide := 30

func _input(event):
	if not active:
		return
	if event is InputEventScreenDrag:
		var swipe = event.relative
		#if swipe.x < -slide:
		#	change_lane(int(clamp(current_lane-1, 0, 2)))
		#elif swipe.x > slide:
		#	change_lane(int(clamp(current_lane+1, 0, 2)))
		if swipe.y < -slide:
			if timer.is_stopped():
				emit_signal("fire")
				timer.start(0.2)
	elif event is InputEventScreenTouch:
		var touch = event.position
		if touch.y < 80 or touch.y > 1120:
			return
		if touch.x < 270:
			change_lane(0)
		elif touch.x > 450:
			change_lane(2)
		else:
			change_lane(1)
	if event.is_action_pressed("ui_left"):
		change_lane(int(clamp(current_lane-1, 0, 2)))
	elif event.is_action_pressed("ui_right"):
		change_lane(int(clamp(current_lane+1, 0, 2)))
	elif event.is_action_pressed("ui_up"):
		if timer.is_stopped():
			emit_signal("fire")
			timer.start(0.2)

func change_lane(new_lane) -> void:
	current_lane = new_lane
	match current_lane:
		LANE.LEFT:
			tween.interpolate_property(self, "global_position:x", global_position.x, x_left, 0.05,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.start()
		LANE.CENTER:
			tween.interpolate_property(self, "global_position:x", global_position.x, x_center, 0.05,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.start()
		LANE.RIGHT:
			tween.interpolate_property(self, "global_position:x", global_position.x, x_right, 0.05,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.start()

func _on_Hitbox_area_entered(area):
	if not active:
		return
	var id = -1
	if area.has_method("get_id"):
		id = area.get_id()
	print("collided with: ", id)
