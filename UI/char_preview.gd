extends Node2D

@export var player:int

func _ready():
	Input.joy_connection_changed.connect(new_joypads)

func new_joypads(id, connected):
	if connected:
		on_player_select(id, "no_character")
	else:
		on_player_select(id, "default")

func on_player_select(player_id, selection):
	if player == player_id:
		$AnimatedSprite2D.play(selection)
