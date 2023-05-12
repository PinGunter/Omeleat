extends Node2D

var positions = {
	0: Vector2(128,600),
	1: Vector2(320,600),
	2: Vector2(900,600),
	3: Vector2(1150,600)
}

@onready var player_manager = $PlayerManager
@onready var screen_shaker = $ScreenShaker
var players = {}

func _ready():
	player_manager.instantiate_players(positions)
	players = player_manager.get_players()
	for p in players:
		players[p].stomped.connect(on_stomped)

func on_stomped(who: int, enemy : int): # depending on the level it works in one way or another (exchanging crown for example)
	# shake screen
	screen_shaker.shake()
	players[enemy].get_stomped()
