extends Node2D

var player_clasification_scene = preload("res://UI/player_clasification.tscn")

var players = {
	0: {0: "froggy", 1: 3},
	1: {0: "wilding", 1: 5},
	2: {0: "very_real", 1: 4},
	3: {0: "pink_guy", 1: 2},
}
var player_positions = {}


func _ready():
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
	
