extends Node2D

@export var sprite: Texture # should be 32x32
@export var action_name : String

signal button_entered(where: String, device :int)
signal button_exited(where: String, device : int)
signal action(what: String)

var last_device : int

func _ready():
	$Area2D/Sprite2D.set("texture",sprite)


func _on_area_2d_area_entered(area):
	if visible:
		var parent = area.get_parent()
		var area_name: String = parent.get("name")
		if area_name.begins_with("cursor"):
			button_entered.emit(name, parent.get("player_controller"))
			last_device = parent.get("player_controller")
			print("Button: " + action_name + " lastDevice: " + str(last_device))



func _on_area_2d_area_exited(area):
	var parent = area.get_parent()
	var area_name: String = parent.get("name")
	if area_name.begins_with("cursor"):
		button_exited.emit(name, parent.get("player_controller"))
		
func launch_action():
	action.emit(action_name)

func force_exit():
	print(action_name + " forcing exit " + str(last_device))
	button_exited.emit(name, last_device)
