extends Node2D

onready var portal1 = preload("res://scenes/machines/portal1.tscn")
onready var portal2 = preload("res://scenes/machines/portal2.tscn")
onready var portal3 = preload("res://scenes/machines/portal3.tscn")

onready var portal = [portal1, portal2, portal3]
var loot = ["weapon_box","cupboard","locker"]
# Called when the node enters the scene tree for the first time.
func _ready():
	var random_generator = RandomNumberGenerator.new()
	random_generator.randomize()
	var random_loot_value = int(random_generator.randf_range(0,3))
	var random_value = int(random_generator.randf_range(1,11))
	var chest = loot[random_loot_value] + String(random_value)
	print(chest)
	print(random_loot_value)
	var portal_instance = portal[random_loot_value].instance()
	portal_instance.position = get_node(chest).get_global_position()
	get_node(chest).free()
	get_tree().get_root().call_deferred("add_child", portal_instance)
