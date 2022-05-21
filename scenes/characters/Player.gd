extends KinematicBody2D

#onready var gun =  get_node("network_gun")
onready var gun =  get_node("gun")
var velocity = Vector2(0,0)

var username_text = load("res://scenes/MainMenu/Usename_text.tscn")

var username setget username_set
var username_text_instance = null

puppet var puppet_position = Vector2(0, 0) setget puppet_position_set
puppet var puppet_velocity = Vector2()
puppet var puppet_username = "" setget puppet_username_set

onready var tween = $Tween

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
	get_tree().connect("network_peer_connected", self, "_network_peer_connected") #here error
	username_text_instance = Global.instance_node_at_location(username_text, Persistent_nodes, global_position)
	username_text_instance.player_following = self
	
	Global.alive_players.append(self)
	
	yield(get_tree(),"idle_frame")
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = self

func _physics_process(_delta):
	if username_text_instance != null:
		username_text_instance.name = "username" + name
	if get_tree().has_network_peer():
		if is_network_master():
			if ALIVE == false:
				#print("game over")
				#$ShakingCamera.
				if username_text_instance != null:
					username_text_instance.visible = false
					
				if get_tree().is_network_server():
					rpc("destroy")
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
		else:
			if not tween.is_active():
				move_and_slide(puppet_velocity * SPEED)
	else:
		#gun.puppet_rotation
		pass


func puppet_position_set(new_value) -> void:
	puppet_position = new_value
	
	tween.Interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
	tween.start()

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

func username_set(new_value) -> void:
	username = new_value
	
	if get_tree().has_network_peer():
		if is_network_master() and username_text_instance != null:
			username_text_instance.text = username
			rset("puppet_username", username)
		
func puppet_username_set(new_value) -> void:
	puppet_username = new_value
	
	if get_tree().has_network_peer():
		if not is_network_master() and username_text_instance != null:
			username_text_instance.text = puppet_username

func _on_Network_tick_rate_timeout():
	if get_tree().has_network_peer():
		if is_network_master():
			rset_unreliable("puppet_position", global_position)
			rset_unreliable("puppet_velocity", velocity)

sync func update_position(pos):
	global_position = pos
	puppet_position = pos
	
sync func enable() -> void:
	username_text_instance.visible = true
	visible = true
	
	if get_tree(). has_network_peer():
		if is_network_master():
			Global.player_master = self
	if not Global.alive_players.has(self):
		Global.alive_players.append(self)
		
sync func destroy() -> void:
	username_text_instance.visible = false
	visible = false
	Global.alive_players.erase(self)
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = null
		
func _exit_tree():
	Global.alive_players.erase(self)
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = null
