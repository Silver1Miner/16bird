extends AudioStreamPlayer

# MUSIC
var tracks = [
	["The Missed Phone Call", preload("res://assets/audio/music/9pm-the-missed-phone-call-114853.mp3")],
	["A Cozy Day", preload("res://assets/audio/music/a-cozy-day-114852.mp3")],
	["Chosen", preload("res://assets/audio/music/chosen-124434.mp3")],
	["Dreamy", preload("res://assets/audio/music/dreamy-114855.mp3")]
]

func play_music(id: int) -> void:
	stream = tracks[id][1]
	play()

# SOUND
var available = []
var queue = []
func _ready():
	UserData.load_settings()
	AudioServer.set_bus_mute(1, UserData.mute_sound)
	AudioServer.set_bus_mute(2, UserData.mute_music)
	play_music(UserData.jukebox_index)
	for i in 4:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_sound_finished", [p])
		p.bus = "Sound"

func _on_sound_finished(next_stream) -> void:
	available.append(next_stream)

func play_sound(sound_path: String) -> void:
	queue.append(sound_path)

func play_slide() -> void:
	randomize()
	var slide = int(rand_range(1,6))
	play_sound("res://assets/audio/sounds/slides/cardSlide" + str(slide) + ".ogg")

func play_place() -> void:
	randomize()
	var place = int(rand_range(1,4))
	play_sound("res://assets/audio/sounds/place/cardPlace" + str(place) + ".ogg")

func play_collide() -> void:
	randomize()
	var collide = int(rand_range(1,4))
	play_sound("res://assets/audio/sounds/collide/chipsCollide" + str(collide) + ".ogg")

func play_throw() -> void:
	randomize()
	var throw = int(rand_range(1,3))
	play_sound("res://assets/audio/sounds/throw/dieThrow" + str(throw) + ".ogg")

func _process(_delta: float) -> void:
	if not queue.empty() and not available.empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()
