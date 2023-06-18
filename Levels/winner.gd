extends Node2D

var player_clasification_scene = preload("res://UI/player_clasification.tscn")
@onready var game_storage = $GameStorage

var players = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	players = game_storage.get_player_ranking()
	var winner = players[0]
	var pl_c = player_clasification_scene.instantiate()
	pl_c.select_character(winner[0])
	pl_c.set("position", Vector2(500,220))
	add_child(pl_c)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
