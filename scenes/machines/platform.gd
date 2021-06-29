extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = 	Vector2(0,0)
var Passenger
var SPEED = -110

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y = SPEED
	Passenger.on_lift(SPEED)
	velocity.x = lerp(velocity.x,0,0.2)
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, 0.785398, false)


func _on_surface_body_entered(body):
	if body.is_in_group("characters"):
		Passenger = body

func _on_surface_body_exited(body):
	if body.is_in_group("characters"):
		body.of_lift()
