extends Node2D

var Player
var closed = true
var timeToaddDestination : float
var ACCESS = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ACCESS == true:
		if closed == true:
			$SoundOpen.play()
			closed = false
			yield(get_tree().create_timer(5),"timeout")
			$AnimatedSprite.play()
			if is_instance_valid(Player):
				Player.Picked = Player.Picked + 1
		if closed == false:
			pass
		if is_instance_valid(Player) && Player.ACCESS == false:
			Player.Picked = 0
		ACCESS = false

func _on_Timer_timeout():
	pass # Replace with function body.
