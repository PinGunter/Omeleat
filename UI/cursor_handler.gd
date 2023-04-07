extends Node


var cursor = preload("res://UI/cursor.tscn")
var n_players = 0

func _ready():
	for n in Input.get_connected_joypads():
		var cursor_instance = cursor.instantiate()
		cursor_instance.set("player_controller", n)
		add_child(cursor_instance)
	n_players = Input.get_connected_joypads().size()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
