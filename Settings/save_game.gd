extends Node

@onready var volume = $VBoxContainer/HBoxContainer/Volume
@onready var volume_txt = $VBoxContainer/HBoxContainer/volumeTxt
@onready var full_screen = $VBoxContainer/HBoxContainer2/Button
@onready var full_screen_txt = $VBoxContainer/HBoxContainer2/fullscreenTxt
@onready var screen_shake_txt = $VBoxContainer/HBoxContainer3/ScreenShakeTxt
@onready var screen_shake = $VBoxContainer/HBoxContainer3/ScreenShakeBtn

var config = {}
var screen_shake_opts = ["Off", "Normal", "High"]
var scr_shk_i = 0


func _ready():
	config = ConfigLoader.get_config()
	volume.value = config["volume"]
	full_screen.text = "ON" if config["fullscreen"] else "OFF"
	full_screen.grab_focus()
	scr_shk_i = int(config["screen_shake"])
	screen_shake.text = screen_shake_opts[scr_shk_i]


func _on_volume_value_changed(value):
	config["volume"] =value
	ConfigLoader.save_config()
	MainMusic.change_volume(value)


func _on_full_screen_pressed():
	config["fullscreen"] = not config["fullscreen"]
	full_screen.text = "ON" if config["fullscreen"] else "OFF"
	if config["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
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


func _on_screen_shake_btn_focus_entered():
	screen_shake_txt.set("text", "[color=#fff]Screen Shake[/color]")


func _on_screen_shake_btn_focus_exited():
	screen_shake_txt.set("text", "[color=#000]Screen Shake[/color]")


func _on_screen_shake_btn_pressed():
	scr_shk_i = (scr_shk_i+1) % screen_shake_opts.size()
	config["screen_shake"] = scr_shk_i
	screen_shake.text = screen_shake_opts[scr_shk_i]
	ConfigLoader.save_config()
