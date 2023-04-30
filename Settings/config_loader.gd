extends Node

const FILE_NAME = "user://settings.json"

var config = {"fullscreen" : false, "volume" : 1.0}
# Called when the node enters the scene tree for the first time.
func _ready():
	load_config()
	if config["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	print(config)

func load_config():
	var file = FileAccess.open(FILE_NAME, FileAccess.READ)
	if file != null:
		var contents = file.get_as_text()
		config = JSON.parse_string(contents)
		file.close()
		
func get_config():
	load_config()
	return config

func save_config():
	var file = FileAccess.open(FILE_NAME, FileAccess.WRITE)
	var json = JSON.stringify(config)
	file.store_string(json)
	file.close()
