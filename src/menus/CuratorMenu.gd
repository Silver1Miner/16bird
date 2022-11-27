extends Control

var tokens = 0 setget _set_tokens
onready var token_display = $Options/Tokens/TokenValue
export var FCT: PackedScene = preload("res://src/effects/FCT.tscn")
onready var coin_button = $Options/Panel/Coins
onready var trade_button = $Options/Panel/Trade
onready var result = $Result
onready var result_name = $Result/Title
onready var result_picture = $Result/TextureRect
onready var duplicate_label = $Result/Duplicate
var duplicate = false

signal coins_spent(cost)

func _ready():
	update_all()

func show_no_funds_warning(rect_pos: Vector2) -> void:
	var fct = FCT.instance()
	add_child(fct)
	fct.rect_position = rect_pos
	fct.show_value("Insufficient Funds!", Vector2(0,-8), 1, PI/2,false,Color(1,1,1),2)
	Audio.play_sound("res://assets/audio/sounds/back_002.ogg")

func update_all() -> void:
	_set_tokens(UserData.tokens)
	result.visible = false

func _set_tokens(new_value: int) -> void:
	tokens = int(clamp(new_value, 0, 999999))
	UserData.tokens = tokens
	token_display.text = str(tokens)

func _on_Coins_pressed():
	if 20 > UserData.coins:
		show_no_funds_warning(coin_button.get_global_rect().position + Vector2(0, -30))
		return
	emit_signal("coins_spent", 20)
	Audio.play_throw()
	roll()

func _on_Trade_pressed():
	if 5 > UserData.tokens:
		show_no_funds_warning(trade_button.get_global_rect().position + Vector2(0, -30))
		return
	_set_tokens(tokens - 5)
	Audio.play_throw()
	roll()

func roll() -> void:
	randomize()
	var choice = int(rand_range(0, UserData.max_pictures-1))
	if choice in UserData.inventory:
		duplicate = true
	else:
		UserData.inventory.append(choice)
		UserData.inventory.sort()
	var data = Images.get_gallery_image(choice)
	result_name.text = data[0]
	result_picture.texture = data[1]
	duplicate_label.visible = duplicate
	result.visible = true

func _on_Accept_pressed():
	result_name.text = ""
	result_picture.texture = null
	result.visible = false
	Audio.play_place()
	if duplicate:
		_set_tokens(tokens + 1)
		duplicate = false
