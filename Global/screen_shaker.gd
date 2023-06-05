extends Node

var initial_shake_strength : float = 30.0
var shake_decay_rate : float = 5.0
var shake_strength : float = 0.0

var rng = RandomNumberGenerator.new()
@onready var camera : Camera2D = get_viewport().get_camera_2d()

func _ready():
	var scr_sk = ConfigLoader.get_config()["screen_shake"]
	if scr_sk == 0:
		initial_shake_strength = 0.0
	elif scr_sk == 1:
		initial_shake_strength = 15.0
	elif scr_sk == 2:
		initial_shake_strength = 30.0

func _process(delta):
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
	camera.offset = get_random_offset()

func get_random_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_strength, shake_strength),
		rng.randf_range(-shake_strength, shake_strength)
	)

func shake():
	shake_strength = initial_shake_strength
