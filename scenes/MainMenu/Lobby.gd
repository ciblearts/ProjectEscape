extends Button

func _on_Lobby_pressed():
	SceneChanger.goto_scene("res://scenes/MainMenu/Menu.tscn", self)
