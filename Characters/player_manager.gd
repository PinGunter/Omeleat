extends Node

@export var needs_pressing : bool = true 
var player_scene = preload("res://Characters/Player.tscn")

var player_instances = {}

func instantiate_players(positions : Dictionary):
	for player in GameStorage.get_players():
		if GameStorage.get_players()[player][0] != "no_character":
			var player_instance : Node2D = player_scene.instantiate()
			add_child(player_instance)
			player_instance.set("controller",player)
			player_instance.set("character", GameStorage.get_players()[player][0])
			player_instance.set("stomp_needs_press", needs_pressing)
			player_instance.position = positions[player]
			player_instance.add_to_group("players")
			player_instances[player] = player_instance
			
			
func instantiate_draw_players(positions: Dictionary):
	var all_players = GameStorage.get_players()
	var drawers = GameStorage.get_drawers()
	for player in drawers:
		if all_players[player][0] != "no_character":
			var player_instance : Node2D = player_scene.instantiate()
			add_child(player_instance)
			player_instance.set("controller",player)
			player_instance.set("character", all_players[player][0])
			player_instance.set("stomp_needs_press", needs_pressing)
			player_instance.position = positions[player]
			player_instance.add_to_group("players")
			player_instances[player] = player_instance
			
func get_players():
	return player_instances
