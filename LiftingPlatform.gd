extends Node2D

const IDLE_DURTION = 1.0

export var move_to = Vector2.UP * 1400
export var speed = 1

var follow = Vector2.ZERO

func _ready():
	_init_tween()
	
func _init_tween():
	var duration = move_to.length() / float(speed * 120)
	$MoveTween.interpolate_property($platform, "position", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURTION )
	$MoveTween.interpolate_property($platform, "position", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURTION * 2)
	$MoveTween.start()
	
#func _physics_process(_delta):
#	$platform.position = $platform.position.linear_interpolate(follow, 0.075)
