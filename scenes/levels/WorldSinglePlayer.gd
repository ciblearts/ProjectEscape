extends Node2D

onready var world = preload("res://scenes/levels/World.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var world_instance = world.instance()
	get_tree().get_root().call_deferred("add_child", world_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
