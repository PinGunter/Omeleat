extends Node2D

var positions = {
	0: Vector2(128,600),
	1: Vector2(320,600),
	2: Vector2(900,600),
	3: Vector2(1150,600)
}

@onready var player_manager = $PlayerManager

func _ready():
	player_manager.instantiate_players(positions)
	

