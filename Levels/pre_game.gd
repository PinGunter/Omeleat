extends Node2D

var game_name = ""
var game_path = ""


func _ready():
	var new_game = GameStorage.pick_next_game()
	game_name = new_game[0]
	game_path = new_game[1]
	$gameName.set("text", "[center]%s[/center]" % game_name)

func _on_timer_timeout():
	SceneTransition.change_scene(game_path)
