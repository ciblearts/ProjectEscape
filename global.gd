extends Node

var player
var object
var effect

var player_master = null
var ui = null

var alive_players = []

func instance_node_at_location(node: Object, parent: Object, location: Vector2) -> Object:
	var node_instance = instance_node(node, parent)
	node_instance.global_position = location
	return node_instance

func instance_node(node: Object, parent: Object) -> Object:
	var node_instance = node.instance()
	parent.add_child(node_instance)
	return node_instance

func register_player(in_player):
	print("Player registered")
	player = in_player
	
func register_object(in_object):
	print("object registered")
	object = in_object

func register_effect(in_effect):
	print("effect registered")
	effect = in_effect
