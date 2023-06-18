extends Node2D

var game_name = ""
var game_path = ""


func _ready():
	if ConfigLoader.get_config()["volume"] == 0:
		$bgMusic.volume_db = -80
	else:
		$bgMusic.volume_db = (1 - ConfigLoader.get_config()["volume"]) * -40
	var new_game = GameStorage.pick_next_game()
	game_name = new_game[0]
	game_path = new_game[1]
	$gameName.set("text", "[center]%s[/center]" % game_name)

func _on_timer_timeout():
	SceneTransition.change_scene(game_path)
