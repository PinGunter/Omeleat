extends Node2D


@onready var selectTexture = $Area2D/Select
@export var texture : Texture2D
@export var characterName: String
@export var player: int

var is_selected = false

signal cursor_entered(where: String, device: int)
signal cursor_exited(where: String, device: int)
signal character_selected(player: String, device : int)

func _ready():
	selectTexture.set("texture", texture)
	Input.joy_connection_changed.connect(check_controllers)


func on_body_entered(body):
	var parent = body.get_parent()
	var b_name = parent.get("name")
	if b_name.begins_with("cursor") and not is_selected:
		cursor_entered.emit(characterName, parent.get("player_controller"))
		

func on_body_exited(body):
	var parent = body.get_parent()
	var b_name = parent.get("name")
	if b_name.begins_with("cursor"):
		cursor_exited.emit(characterName, parent.get("player_controller"))

func check_controllers(device, connected):
	if not connected and device == player:
		deselect()
			


func select(device : int):
	is_selected = true
	player = device
	$Area2D/Frame.play("select_"+str(device))
	character_selected.emit(player, device)

func deselect():
	is_selected = false
	player = -1
	$Area2D/Frame.play("default")


func _input(event):
	if player != -1 and event.is_action_pressed("back_"+str(player)):
		deselect()
