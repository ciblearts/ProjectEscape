extends KinematicBody2D

var SPEED = 350
var velocity = Vector2(0,0)
var GRAVITY = 35
var INERTIA = 350
const JUMPFORCE = -1100
var cover = false
var ALIVE = true
var WIN = false
var HIDE = false
var Picked = 0
export var ACCESS = false
var DIRECTION = 'left'
var LADDER = false
var VEST = true

#var blood = load('res://scenes/objects/Blood.tscn')

func _physics_process(_delta):
	if !ALIVE:
		queue_free()
	if WIN == true && ALIVE:
		queue_free()
	if Input.is_action_pressed("sprint"):
		SPEED = 900
	else:
		SPEED = 350
	#$Sprite.play("idle")
	#if not is_on_floor():
	#	$Sprite.play("air")
		
	velocity.y = velocity.y + GRAVITY	
	velocity.x = lerp(velocity.x,0,0.2)
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, 0.785398, false)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * INERTIA)

func _integrate_forces(state):
	var delta = state.get_step()
	# Steer towards player
	var distance_to_player = global_position.distance_to($"root/Global/".gameboy.global_position)
	var vector_to_player = ($"root/Global/".gameboy.global_position - global_position).normalized()
	print(distance_to_player)
	if distance_to_player > 150:
		# Move towards player
		velocity += vector_to_player * SPEED * delta
		$Sprite.play("walk")
		$Sprite.flip_h = false
		$vest.flip_h = false
		$"head phone military".flip_h = false
		#hovering = false
	else:
		# Move away from player
		#hovering = false
		velocity += -vector_to_player * SPEED * delta

func hide():
	$gun/Light2D.hide()
	$"cardboard box".show()
	#$SoundCardboard.play()

func unhide():
	$gun/Light2D.show()
	#$SoundCardboardOpen.play()
	$"cardboard box".hide()
	HIDE = true

func jump():
	if is_on_floor() :
		velocity.y = JUMPFORCE
		$SoundJump.play()

func walk():
		if $SoundSteps.playing == false && is_on_floor():
			$SoundSteps.play_random()
		if DIRECTION == 'left':
			velocity.x = -SPEED
			$Sprite.play("walk")
			$Sprite.flip_h = true
			$vest.flip_h = true
			$"head phone military".flip_h = true
		elif DIRECTION == 'right':
			velocity.x = SPEED
			$Sprite.play("walk")
			$Sprite.flip_h = false
			$vest.flip_h = false
			$"head phone military".flip_h = false
			
func vest(flag):
	if flag == true:
		VEST = true
		$vest.show()
		$SoundVest.play()
	elif flag == false:
		VEST = false
		$vest.hide()
		$SoundVestBullet.play()

func climb():
	if LADDER == true:
		velocity.y = -SPEED

func fall_left_reset():
	var player_instance = get_node(".")
	player_instance.position.x = 0
	#get_parent().call_deferred("add_child", player_instance)
	
func fall_right_reset():
	var player_instance = get_node(".")
	player_instance.position.x = 19220
	#get_parent().call_deferred("add_child", player_instance)
	
func fall_y_reset():
	var player_instance = get_node(".")
	player_instance.position.y = 0

func _body_entered_ladder():
	LADDER = true
	climb()

func _body_exited_ladder():
	LADDER = false

func _body_entered_fan():
	velocity.y = JUMPFORCE * 2

func _on_right_resetter_body_entered(_body):
	fall_left_reset()

func _on_left_resetter_body_entered(_body):
	fall_right_reset()

func _on_down_resetter_body_entered(_body):
	$SoundAaaahhh.play()
	fall_y_reset()

func win():
	queue_free()
