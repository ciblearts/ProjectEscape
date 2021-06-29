extends Area2D


func _on_fan_body_entered(body):
	if body.is_in_group("characters"):
		body._body_entered_fan()


func _on_fan_body_exited(body):
	if body.is_in_group("characters"):
		#body._body_exited_fan()
		pass
