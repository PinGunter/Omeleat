extends Node2D


@onready var selectTexture = $Area2D/Select
@export var texture : Texture2D
@export var characterName: String
@export var player: int

var is_selected = false

signal cursor_entered(where: String, device: int)
signal cursor_exited(where: String, device: int)

func _ready():
	selectTexture.set("texture", texture)


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


func select(device : int):
	is_selected = true
	player = device
	$Area2D/Frame.play("select_"+str(device))

func deselect():
	is_selected = false
	player = -1
	$Area2D/Frame.play("default")
