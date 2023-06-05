extends Node2D

const INITIAL_SPAWN_INTERVAL = 2.0
const SPAWN_INTERVAL_MAX = 0.5
const INCREMENTAL_VELOCITY = 20
const MAX_BOXES_PER_COLUMN = 14

const NUM_COLUMNS = 10

var spawnInterval = INITIAL_SPAWN_INTERVAL
var timer = 0.0 

var positions = {
	0: Vector2(500,520),
	1: Vector2(600,600),
	2: Vector2(700,600),
	3: Vector2(800,600)
}

@onready var player_manager = $PlayerManager
var box_scene = preload("res://Levels/Caja.tscn")

var boxesPerColumn = []

func _ready():
	player_manager.instantiate_players(positions)
	for i in range(NUM_COLUMNS):
		boxesPerColumn.append(0)

func _process(delta):
	timer += delta
	if timer >= spawnInterval:
		timer = 0.0
		spawn_box()
		if spawnInterval > SPAWN_INTERVAL_MAX:
			spawnInterval -= 0.02

func spawn_box():
	var column = randi_range(0, NUM_COLUMNS - 1)
	if boxesPerColumn[column] < MAX_BOXES_PER_COLUMN:
		var box : Node2D = box_scene.instantiate()
		box.global_position = Vector2(column * 50 + 449, -100)
		box.set_velocity(box.get_velocity() + INCREMENTAL_VELOCITY)
		add_child(box)
		boxesPerColumn[column] += 1

	
