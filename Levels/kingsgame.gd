extends Node2D

var positions = {
	0: Vector2(300,300),
	1: Vector2(500,300),
	2: Vector2(700,300),
	3: Vector2(900,300)
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
	if players[enemy].get("has_crown"):
		players[enemy].lose_crown()
		players[who].receive_crown()
	screen_shaker.shake()
	players[enemy].get_stomped()


func _on_tortilla_entered(body):
	if body.is_in_group("players"):
		body.receive_crown()
		$Tortilla1.queue_free()
