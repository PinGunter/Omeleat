extends Node

var player_scene = preload("res://Characters/Player.tscn")

var player_instances = {}

func instantiate_players(positions : Dictionary):
	for player in GameStorage.get_players():
		if GameStorage.get_players()[player][0] != "no_character":
			var player_instance : Node2D = player_scene.instantiate()
			add_child(player_instance)
			player_instance.set("controller",player)
			player_instance.set("character", GameStorage.get_players()[player][0])
			player_instance.position = positions[player]
			player_instances[player] = player_instance
			
