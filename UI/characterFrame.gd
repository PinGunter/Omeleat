extends Node2D


@onready var select = $Area2D/Select
@export var texture : Texture2D
@export var characterName: String

signal cursor_entered(where: String, device: int)
signal cursor_exited(where: String, device: int)

func _ready():
	select.set("texture", texture)


func on_body_entered(body):
	var parent = body.get_parent()
	var b_name = parent.get("name")
	if b_name.begins_with("cursor"):
		cursor_entered.emit(characterName, parent.get("player_controller"))
		

func on_body_exited(body):
	var parent = body.get_parent()
	var b_name = parent.get("name")
	if b_name.begins_with("cursor"):
		cursor_exited.emit(characterName, parent.get("player_controller"))


