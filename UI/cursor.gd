extends Node2D


@onready var cursor = $Pointer
@export var player_controller: int
var mouse_pos = Vector2.ZERO
var mouse_speed = 600.0
var mouse_rel = Vector2.ZERO

#func _ready():
#	Input.set("mouse_mode", Input.MOUSE_MODE_CONFINED)
	
func _process(delta):

#	mouse_pos = get_global_mouse_position()
	var horizontal = Input.get_axis("left_"+str(player_controller), "right_"+str(player_controller))
	var vertical = Input.get_axis("down_"+str(player_controller), "up_"+str(player_controller))
	

#	var vertical = Input.get_joy_axis(player_controller,JOY_AXIS_LEFT_Y)
#	var horizontal = Input.get_joy_axis(player_controller,JOY_AXIS_LEFT_X)
	
#	if (abs(vertical) > 0.01 and abs(horizontal) > 0.01):
	mouse_rel += Vector2.UP * vertical * delta *mouse_speed;
	mouse_rel += Vector2.RIGHT * horizontal * delta*mouse_speed;
	var next_position = mouse_pos+mouse_rel
	next_position.x = clamp(next_position.x, 0, get_tree().get_root().get("size").x)
	next_position.y = clamp(next_position.y, 0, get_tree().get_root().get("size").y)
#	Input.warp_mouse(next_position)
	cursor.position = next_position
	mouse_rel = next_position

