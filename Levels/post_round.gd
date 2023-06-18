extends Node2D

var player_clasification_scene = preload("res://UI/player_clasification.tscn")

var players = {}


func _ready():
	# get the players ranking by points
	players = GameStorage.get_player_ranking()
	var i = 0
	for p in players:
		var pl_c = player_clasification_scene.instantiate()
		pl_c.select_character(players[p][0])
		pl_c.set_points(players[p][1])
		pl_c.set("position", Vector2(100 + i*300,220))
		add_child(pl_c)
		i += 1

func _on_timer_timeout():
	if GameStorage.next_round():
		SceneTransition.change_scene("res://Levels/character_selection.tscn")
	else:
		SceneTransition.change_scene("res://Levels/character_selection.tscn")
	
