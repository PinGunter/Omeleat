extends Node2D

var player_clasification_scene = preload("res://UI/player_clasification.tscn")

var players = {}


func _ready():
	# get the players ranking by points
	players = GameStorage.get_player_ranking()
	var i = 0
	for p in players:
		var pl_c = player_clasification_scene.instantiate()
		pl_c.select_character(p[0])
		pl_c.set_points(p[1])
		pl_c.set("position", Vector2(100 + i*300,220))
		add_child(pl_c)
		i += 1

func _on_timer_timeout():
	if GameStorage.next_round():
		SceneTransition.change_scene("res://Levels/pre_game.tscn")
	else:
		SceneTransition.change_scene("res://Levels/winner.tscn")
	
