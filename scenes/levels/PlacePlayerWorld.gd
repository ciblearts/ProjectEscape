extends Node2D

onready var player = preload("res://scenes/characters/gameboy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var random_generator = RandomNumberGenerator.new()
	random_generator.randomize()
	var random_value = int(random_generator.randf_range(1,9))
	var player_instance = player.instance()
	var robot = "bot" + String(random_value)
	player_instance.position = get_node(robot).get_global_position()
	get_node(robot).free()
	get_tree().get_root().call_deferred("add_child", player_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
