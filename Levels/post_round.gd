extends Node2D

var player_clasification_scene = preload("res://UI/player_clasification.tscn")

var players = {}
var initial_draw_position : int = 0


func _ready():
	if ConfigLoader.get_config()["volume"] == 0:
		$music.volume_db = -80
	else:
		$music.volume_db = (1 - ConfigLoader.get_config()["volume"]) * -40
	# get the players ranking by points
	players = GameStorage.get_player_ranking()
	
	var num_players = players.size()
	if(num_players == 2):
		initial_draw_position = 400
	elif(num_players == 3):
		initial_draw_position = 250
	else: initial_draw_position = 100
	
	var i = 0
	for p in players:
		var pl_c = player_clasification_scene.instantiate()
		pl_c.select_character(p[0])
		pl_c.set_points(p[1])
		pl_c.set("position", Vector2(initial_draw_position + i*300,220))
		add_child(pl_c)
		i += 1

func _on_timer_timeout():
	if GameStorage.next_round():
		SceneTransition.change_scene("res://Levels/pre_game.tscn")
	else:
		SceneTransition.change_scene("res://Levels/winner.tscn")
	
