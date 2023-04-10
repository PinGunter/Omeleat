extends Node2D

var MAX_X = 1280
var MAX_Y = 720

@onready var cursor = $cursorArea/Pointer
@onready var body = $cursorArea
@export var player_controller: int

var mouse_pos = Vector2.ZERO
var mouse_speed = 600.0
var mouse_rel = Vector2.ZERO

var clickable

signal clicked(who: int, where: String)

func _ready():
	name = "cursor"+str(player_controller)
	
func _process(delta):

	var horizontal = Input.get_axis("left_"+str(player_controller), "right_"+str(player_controller))
	var vertical = Input.get_axis("down_"+str(player_controller), "up_"+str(player_controller))
	
	mouse_rel += Vector2.UP * vertical * delta *mouse_speed;
	mouse_rel += Vector2.RIGHT * horizontal * delta*mouse_speed;
	var next_position = mouse_pos+mouse_rel
	next_position.x = clamp(next_position.x, 0, MAX_X)
	next_position.y = clamp(next_position.y, 0, MAX_Y)


	body.position = next_position
	mouse_rel = next_position
	
	if Input.is_action_just_pressed("accept_"+str(player_controller)) and clickable != null:
		clicked.emit(player_controller, clickable)
	

func set_player(n : int):
	if n >= 0 and n < 4:
		player_controller = n
		cursor.play("pointer_"+str(player_controller))

func set_is_hand(isHand: bool, click: String):
	if isHand:
		cursor.play("handy_"+str(player_controller))
		clickable = click
	else:
		cursor.play("pointer_"+str(player_controller))
		clickable = null
