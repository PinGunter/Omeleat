extends Node2D

var player_clasification_scene = preload("res://UI/player_clasification.tscn")
@onready var game_storage = $GameStorage

var players = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	players = game_storage.get_player_ranking()
	var winner = players[0]
	var pl_c = player_clasification_scene.instantiate()
	pl_c.select_character(winner[0])
	pl_c.set("position", Vector2(520,240))
	add_child(pl_c)
	$GPUParticles2D.emitting = true
	$GPUParticles2D2.emitting = true
	$GPUParticles2D3.emitting = true
	$winnerMusic.play()



func _on_timer_timeout():
	SceneTransition.change_scene("res://Levels/main_menu.tscn")
