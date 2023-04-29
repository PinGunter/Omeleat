extends Node

const FILE_NAME = "user://save_game.json"
@onready var volume = $div/Volume
@onready var full_screen = $div/FullScreen

var config = {
	"volume": 0.5,
	"fullscreen" : false
}

func save_config():
	var file = FileAccess.open(FILE_NAME, FileAccess.WRITE)
	var json = JSON.stringify(config)
	file.store_string(json)
	file.close()

func load_config():
	var file = FileAccess.open(FILE_NAME, FileAccess.READ)
	if file != null:
		var contents = file.get_as_text()
		config = JSON.parse_string(contents)
		file.close()

func set_volume(value: float):
	config["volume"] = value
	save_config()

func set_fullscreen(value: bool):
	config["fullscreen"] = value
	save_config()
	


func _on_volume_value_changed(value):
	config["volume"] =value
	save_config()


func _on_full_screen_pressed():
	config["fullscreen"] = not config["fullscreen"]
	save_config()
