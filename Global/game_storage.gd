extends Node

var total_rounds : int = 0
var current_round : int = 0
var current_level: String = ""

var levels : Array = [
	["Picnic King", "res://Levels/kingsGame/kingsgame.tscn"],
	["Smashed!" , "res://Levels/BoxLevel/BoxLevel.tscn"]
]

var unplayed_levels : Array = levels.duplicate()
var played_levels : Array = []


# nested dictionary
# for each player we have a dictionary with the character name at position 0 and their points at position 1
var players = {
	0: {0: "no_character", 1: 0},
	1: {0: "no_character", 1: 0},
	2: {0: "no_character", 1: 0},
	3: {0: "no_character", 1: 0},
}

var drawers = [] # ids of the players that have drawn in a game

func get_drawers() -> Array:
	return drawers

func set_drawers(new_dr : Array) -> void:
	drawers = new_dr
	
func set_total_rounds(r : int) -> void:
	total_rounds = r

func get_players() -> Dictionary:
	return players
	
func get_active_players() -> Dictionary:
	var active = {}
	if drawers.size() > 0:
		for d in drawers:
			active[d] = players[d]
	else:
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
	
func get_player_ranking() -> Array:
	var active_players = get_active_players()
	var scores = []
	for p in active_players:
		scores.push_back([active_players[p][0], active_players[p][1]])
	scores.sort_custom(func(a, b): return a[1] > b[1])
	return scores

func get_player_points(player: int) -> int:
	return players[player][1]

func next_round() -> bool:
	current_round += 1
	
	var ranking = get_player_ranking()
	var first = ranking[0][1]
	
	drawers = [find_player_id(ranking[0][0])]
	for p in range(1,ranking.size()):
		if ranking[p][1] == first:
			drawers.push_back(find_player_id(ranking[p][0]))
	drawers.filter(func (n): return n != -1)
	print(drawers)
	if current_round >= total_rounds and drawers.size() == 1:
		return false
	else:
		drawers.clear()
		return true

func pick_next_game() -> Array: # 0: name, 1: path
	if unplayed_levels.size() == 0:
		unplayed_levels = levels.duplicate()
		played_levels.clear()
	
	var rng = RandomNumberGenerator.new()
	var picked = rng.randi_range(0,unplayed_levels.size()-1)
	var level_name = unplayed_levels[picked][0]
	current_level = unplayed_levels[picked][1]
	played_levels.push_back(unplayed_levels[picked].duplicate())
	unplayed_levels.remove_at(picked)
	return [level_name, current_level]
	
func find_player_id(character : String) -> int:
	for p in players:
		if players[p][0] == character:
			return p
	return -1
