extends Node

@onready var volume = $VBoxContainer/HBoxContainer/Volume
@onready var volume_txt = $VBoxContainer/HBoxContainer/volumeTxt
@onready var full_screen = $VBoxContainer/HBoxContainer2/Button
@onready var full_screen_txt = $VBoxContainer/HBoxContainer2/fullscreenTxt

var config = {}

func _ready():
	config = ConfigLoader.get_config()
	volume.value = config["volume"]
	full_screen.text = "ON" if config["fullscreen"] else "OFF"
	full_screen.grab_focus()

func set_volume(value: float):
	config["volume"] = value
	ConfigLoader.save_config()

func set_fullscreen(value: bool):
	config["fullscreen"] = value
	ConfigLoader.save_config()
	
func _on_volume_value_changed(value):
	config["volume"] =value
	ConfigLoader.save_config()


func _on_full_screen_pressed():
	config["fullscreen"] = not config["fullscreen"]
	full_screen.text = "ON" if config["fullscreen"] else "OFF"
	ConfigLoader.save_config()


func _on_button_focus_entered():
	full_screen_txt.set("text", "[color=#fff]"+"Fullscreen"+"[/color]")


func _on_volume_focus_entered():
	volume_txt.set("text", "[color=#fff]"+"Volume"+"[/color]")


func _on_volume_focus_exited():
	volume_txt.set("text", "[color=#000]"+"Volume"+"[/color]")


func _on_button_focus_exited():
	full_screen_txt.set("text", "[color=#000]"+"Fullscreen"+"[/color]")
	
func _input(event):
	for i in range(4):
		if event.is_action_pressed("back_"+str(i)):
			SceneTransition.change_scene("res://UI/main_menu.tscn")
