extends Node2D

const INITIAL_SPAWN_INTERVAL = 2.0
const SPAWN_INTERVAL_MAX = 0.5
const SPAWN_INCREMENTAL = 0.1
const INCREMENTAL_GRAVITY = 10
const MAX_BOXES_PER_COLUMN = 14

const NUM_COLUMNS = 4

var spawnInterval = INITIAL_SPAWN_INTERVAL
var timer = 0.0 
var players = {}
var player_positions = {}
var last_position = 0
var endGame = false
var winnerName = null
var winnerId = null

var gravityBox = 100

var positions = {
	0: Vector2(500,520),
	1: Vector2(600,600),
	2: Vector2(700,600),
	3: Vector2(800,600)
}

@onready var player_manager = $PlayerManager
var box_scene = preload("res://Levels/BoxLevel/Caja.tscn")
var player_points_scene = preload("res://UI/player_points.tscn")

var boxesPerColumn = []

func _ready():
	if ConfigLoader.get_config()["volume"] == 0:
		$bgMusic.volume_db = -80
	else:
		$bgMusic.volume_db = (1 - ConfigLoader.get_config()["volume"]) * -40
	
	player_manager.instantiate_players(positions)
	players = player_manager.get_players()
	for i in range(players.size()):
		players[i].set_scale(Vector2(1.5, 1.5))
	for i in range(NUM_COLUMNS):
		boxesPerColumn.append(0)
	var i=0
	for p in players:
		var pl_p = player_points_scene.instantiate()
		pl_p.scale = Vector2(1.5, 1.5)
		pl_p.select_character(players[p].get("character"))
		pl_p.set("position", Vector2(280,150+i*20))
		add_child(pl_p)
		player_positions[p] = pl_p
		i += 1
	last_position = players.size()

func _process(delta):
	timer += delta
	if timer >= spawnInterval and !endGame:
		timer = 0.0
		spawn_box()
		if spawnInterval > SPAWN_INTERVAL_MAX:
			spawnInterval -= SPAWN_INCREMENTAL

func spawn_box():
	var minNumBoxesInColum = boxesPerColumn.min()
	print(boxesPerColumn)
	print(minNumBoxesInColum)
	var column = randi_range(0, NUM_COLUMNS - 1)
	while((boxesPerColumn[column] > minNumBoxesInColum + 2) or (boxesPerColumn[column] > MAX_BOXES_PER_COLUMN)):
		column = randi_range(0, NUM_COLUMNS - 1)
		print("no nace")
	
	var box : Node2D = box_scene.instantiate()
	box.global_position = Vector2(column * 50 + 449, -100)
	box.set_gravity(gravityBox)
	gravityBox += INCREMENTAL_GRAVITY
	box.smash.connect(smash_player)
	add_child(box)
	boxesPerColumn[column] += 1
	print("columna " + str(column))
		
func smash_player(player : int):
	players[player].aplastar()
	var clasificated = null
	if last_position == 4:
		clasificated = "4th"
	elif last_position == 3:
		clasificated = "3rd"
	elif last_position == 2:
		clasificated = "2nd"
	else: clasificated = "1st"

	player_positions[player].set_points_string(clasificated)
	last_position -= 1
	
	if last_position == 1:
		var players_alive = get_tree().get_nodes_in_group("players")
		for p in players_alive:
			if p.get("controller") != player:
				winnerId = p.get("controller")
				winnerName = p.get("character")
		player_positions[winnerId].set_points_string("1st")
		endGame = true
		end_game()


func end_game():
	$WinnerBanner.z_index = 999
	$WinnerBanner.set_winner(winnerName)	
	GameStorage.update_points(winnerId,GameStorage.get_player_points(winnerId)+1)
	$roundEndTimer.start()




func _on_round_end_timer_timeout():
	SceneTransition.change_scene("res://Levels/character_selection.tscn")


func _on_bg_music_finished():
	$bgMusic.play()
