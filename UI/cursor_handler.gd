extends Node


var cursor_scene = preload("res://UI/cursor.tscn")
signal cursor_clicked(device: int, where: String)

var cursors = {}

func add_cursor(n: int):
	var cursor_instance = cursor_scene.instantiate()
	cursors[n] = cursor_instance
	add_child(cursor_instance)
	cursor_instance.set_player(n)
	cursor_instance.clicked.connect(handle_click)

func _ready():
	Input.joy_connection_changed.connect(check_controllers)
	for n in Input.get_connected_joypads():
		add_cursor(n)

	
func check_controllers(device, connected):
	print(Input.get_connected_joypads())
	if device in cursors and not connected:
		cursors[device].queue_free()
		cursors.erase(device)
	if device not in cursors and connected:
		add_cursor(device)
	
func set_cursor_state(device, click, state):
	if device in cursors:
		cursors[device].set_is_hand(state, click)
		
		
func handle_click(who: int, where: String):
	cursor_clicked.emit(who, where)
	
