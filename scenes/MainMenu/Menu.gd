extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Single_Player_pressed():
	SceneChanger.goto_scene("res://scenes/levels/WorldSinglePlayer.tscn", self)

func _on_Options_pressed():
	SceneChanger.goto_scene("res://scenes/MainMenu/Options.tscn", self)

func _on_Multiplayer_pressed():
	SceneChanger.goto_scene("res://scenes/MainMenu/Network_setup.tscn", self)
	pass

func _on_Practice_Level_pressed():
	#SceneChanger.goto_scene("res://scenes/levels/Practice level.tscn", self)
	pass

func _on_Story_pressed():
	SceneChanger.goto_scene("res://scenes/MainMenu/Story.tscn", self)

func _on_Exit_pressed():
	get_tree().quit()
