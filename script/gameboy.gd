extends KinematicBody2D

onready var gun =  get_node("gun")
var velocity = Vector2(0,0)

var cover = false
var ladder_on = false
var ALIVE = true
var action = false
var ACCESS = false
var WIN = false
var VEST = true

var Picked = 0
var SPEED = 350
var GRAVITY = 35
var INERTIA = 350
var LIFT = 0
const JUMPFORCE = -1100
var machine

func _ready():
	$"/root/Global".register_player(self)

func _physics_process(_delta):
	if ALIVE == false:
		#print("game over")
		#$ShakingCamera.
		queue_free()
		var _new_scene = get_tree().change_scene("res://scenes/levels/game over.tscn")
		return
	if WIN == true:
		queue_free()
		var _new_scene = get_tree().change_scene("res://scenes/levels/WeaponBoxWin.tscn")
		return

	if Picked>0 :
		$SoundReload.play()
		gun.bullets = gun.bullets + Picked
		Picked = 0
	
	if Input.is_action_pressed("sprint"):
		SPEED = 900
	else:
		SPEED = 350
	
	if Input.is_action_just_pressed("action"):
		if ACCESS == true:
			if machine.ACCESS == false:
				machine.ACCESS = true
				machine.Player = self
				
			elif machine.ACCESS == true:
				machine.ACCESS = false
				machine.Player = 0
	
	if ladder_on == true:
		if Input.is_action_pressed("up"):
			velocity.y = -SPEED
			$Sprite.play("climb")
			$SoundJump.play()
		elif Input.is_action_pressed("down"):
			velocity.y = +SPEED
			$Sprite.play("climb")
		else:
			$Sprite.play("idle")
		if not is_on_floor():
			#$Sprite.play("air")
			pass
		velocity.y = lerp(velocity.y,0,0.2)
		velocity = move_and_slide(velocity, Vector2.UP, false, 4, 0.785398, false)

	if Input.is_action_just_pressed("cover"):
		if cover == false:
			$gun/Light2D.hide()
			$SoundCardboard.play()
			cover = true
			$"cardboard box".show()
		elif cover == true:
			$gun/Light2D.show()
			$SoundCardboardOpen.play()
			cover = false
			$"cardboard box".hide()
	
	if Input.is_action_pressed("right"):
		#if is_on_floor():
			#$SoundSteps.play_random()
		velocity.x = SPEED
		$Sprite.play("walk")
		$Sprite.flip_h = false
		$vest.flip_h = false
		$"head phone military".flip_h = false
		
	elif Input.is_action_pressed("left"):
		#if is_on_floor():
			#$SoundSteps.play_random()
		velocity.x = -SPEED
		$Sprite.play("walk")
		$Sprite.flip_h = true
		$vest.flip_h = true
		$"head phone military".flip_h = true
	else:
		$Sprite.play("idle")
	
	if not is_on_floor():
		$Sprite.play("air")
		
	velocity.y = velocity.y + GRAVITY
	
	if Input.is_action_just_pressed("jump") and is_on_floor() :
		velocity.y = JUMPFORCE
		$SoundJump.play()
	velocity.x = lerp(velocity.x,0,0.2)
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, 0.785398, false)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * INERTIA)

func on_lift(var lift):
	LIFT = lift/2
	
func of_lift():
	LIFT = 0
	
func _body_entered_ladder():
	GRAVITY = 0
	ladder_on = true

func _body_exited_ladder():
	GRAVITY = 35
	ladder_on = false

func _body_entered_fan():
		velocity.y = JUMPFORCE * 2

func fall_left_reset():
	var player_instance = get_node(".")
	player_instance.position.x = 0
	#get_parent().call_deferred("add_child", player_instance)
	
func fall_right_reset():
	var player_instance = get_node(".")
	player_instance.position.x = 18900
	#get_parent().call_deferred("add_child", player_instance)
	
func fall_y_reset():
	var player_instance = get_node(".")
	player_instance.position.y = 0

func vest(flag):
	if flag == true:
		VEST = true
		$vest.show()
		$SoundVest.play()
	elif flag == false:
		$ShakingCamera.set_shake(1)
		VEST = false
		$vest.hide()
		$SoundVestBullet.play()

func _on_right_resetter_body_entered(_body):
	print("right")
	fall_left_reset()

func _on_down_resetter_body_entered(_body):
	$SoundAaaahhh.play()
	fall_y_reset()

func _on_left_resetter_body_entered(_body):
	print("left")
	fall_right_reset()

func _on_Access_range_area_entered(area):
	if area.is_in_group("machines"):
		ACCESS = true
		machine = area

func _on_Access_range_area_exited(_area):
	#machine.Player = null
	ACCESS = false
