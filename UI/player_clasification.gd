extends Node2D

@export_enum("wilding", "froggy", "very_real", "pink_guy") var character: String

func select_character(char : String):
	character = char
	$icon.play(character)
	
func set_points(p : int):
	$point.set("text", "[center]"+str(p)+"[/center]")
	


func _ready():
	$icon.play(character)
