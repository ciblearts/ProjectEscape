extends AudioStreamPlayer2D

# In Godot 3.1 you can export the Array instead
var samples = [
	preload("res://sounds/step_001.wav"),
	preload("res://sounds/step_002.wav")
]

func _ready():
	randomize()

func play_random():
	# In Godot 3.1 you can use Array.shuffle() after going through the sounds
	stream = samples[randi() % samples.size()]
	play()
