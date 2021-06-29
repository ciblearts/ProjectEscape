extends Node2D

var broken = false
var switch = false

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("characters") && broken == false && switch == false:
		switch = true
		$"pin/lamp/Light2D".show()

func _on_Area2D2_body_exited(body):
	if body.is_in_group("characters") && switch == true:
		switch = false
		$"pin/lamp/Light2D".hide()
