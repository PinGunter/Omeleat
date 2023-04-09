extends Node


var cursor_scene = preload("res://UI/cursor.tscn")

var cursors = {}

func _ready():
	Input.joy_connection_changed.connect(check_controllers)
	for n in Input.get_connected_joypads():
		var cursor_instance = cursor_scene.instantiate()
		cursors[n] = cursor_instance
		add_child(cursor_instance)
		cursor_instance.set_player(n)

	
	
func check_controllers(device, connected):
	print(Input.get_connected_joypads())
	if device in cursors and not connected:
		cursors[device].queue_free()
		cursors.erase(device)
	if device not in cursors and connected:
		cursors[device] = cursor_scene.instantiate()
		add_child(cursors[device])
		cursors[device].set_player(device)
	
func set_cursor_state(device, state):
	if device in cursors:
		cursors[device].set_is_hand(state)
