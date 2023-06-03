extends Node

var total_rounds : int = 0
var current_round : int = 1

# nested dictionary
# for each player we have a dictionary with the character name at position 0 and their points at position 1
var players = {
	0: {0: "froggy", 1: 0},
	1: {0: "very_real", 1: 0},
	2: {0: "no_character", 1: 0},
	3: {0: "no_character", 1: 0},
}

func get_players() -> Dictionary:
	return players
	
func get_active_players() -> Dictionary:
	var active = {}
	for p in players:
		if players[p][0] != "no_character":
			active[p] = players[p]
	return active
		

func update_player(player : int, character : String) -> void:
	if player >= 0 and player <= 4:
		players[player][0] = character

func update_points(player: int, new_points : int) -> void:
	if player >= 0 and player <= 4:
		players[player][1] = new_points
		

func get_player_points(player: int) -> int:
	return players[player][1]

func next_round() -> bool:
	current_round += 1
	if current_round > total_rounds:
		return false
	else:
		return true
