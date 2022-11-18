extends AudioStreamPlayer

# SOUND
var available = []
var queue = []
func _ready():
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
	var slide = int(rand_range(1,8))
	play_sound("res://assets/audio/sounds/cardSlide" + str(slide) + ".ogg")

func _process(_delta: float) -> void:
	if not queue.empty() and not available.empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()
