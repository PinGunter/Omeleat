extends Node2D

@export_enum("wilding", "froggy", "very_real", "pink_guy") var character: String

func select_character(char : String):
	character = char
	$icon.play(character)

func set_winner(is_winner: bool):
	$winner.visible = is_winner

func set_points(p : int):
	$point.set("text", str(p))

func _ready():
	$icon.play(character)
