extends RigidBody2D

var explotion = preload("res://scenes/objects/explotion.tscn")
var blood = load('res://scenes/objects/Blood.tscn')

func _on_RigidBody2D_body_entered(body):
	if body.is_in_group("characters"):
		if body.VEST == true:
			body.vest(false)
		else:
			body.ALIVE = false
			var blood_instance = blood.instance()
			print(get_tree())
			get_tree().get_root().add_child(blood_instance)
			blood_instance.global_position = global_position
			blood_instance.rotation_degrees = rotation_degrees
	var explotion_instance = explotion.instance()
	explotion_instance.position = get_global_position()
	get_tree().get_root().add_child(explotion_instance)
	queue_free()
