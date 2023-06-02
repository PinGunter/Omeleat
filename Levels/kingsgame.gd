extends Node2D

@export var game_duration : int = 60;
@export var slowness_mode : bool = false
@export var stomping_needs_press : bool = true

var positions = {
	0: Vector2(300,300),
	1: Vector2(500,300),
	2: Vector2(700,300),
	3: Vector2(900,300)
}

@onready var player_manager = $PlayerManager
@onready var screen_shaker = $ScreenShaker 
@onready var round_timer_text = $roundTimeNode/roundTime
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer
@onready var winner_banner = $WinnerBanner

var slowness = 50
var players = {}
var points = {0: 0, 1: 0, 2: 0, 3:0}
var max_points = 0
var text_color = "#000"
var player_points_scene = preload("res://UI/player_points.tscn")
var player_points = {}

func _ready():
	if ConfigLoader.get_config()["volume"] == 0:
		$bgMusic.volume_db = -80
	else:
		$bgMusic.volume_db = (1 - ConfigLoader.get_config()["volume"]) * -40
		
	player_manager.set("needs_pressing", stomping_needs_press)
	player_manager.instantiate_players(positions)
	players = player_manager.get_players()
	var i=0
	for p in players:
		players[p].stomped.connect(on_stomped)
		var pl_p = player_points_scene.instantiate()
		pl_p.select_character(players[p].get("character"))
		pl_p.set("position", Vector2(280,150+i*20))
		add_child(pl_p)
		player_points[p] = pl_p
		i += 1
		
	

func on_stomped(who: int, enemy : int): # depending on the level it works in one way or another (exchanging crown for example)
	if players[enemy].get("has_crown"):
		players[enemy].lose_crown()
		players[who].receive_crown()
		screen_shaker.shake()
		$pickup.play()
	players[enemy].get_stomped()


func _on_tortilla_entered(body):
	if body.is_in_group("players"):
		$pickup.play()
		body.receive_crown()
		$Tortilla1.queue_free()

func end_game():
	var winners = []
	for p in players:
		if points[p] == max_points:
			winners.push_back(p)
	timer.stop()
	round_timer_text.set("text", "")
	if winners.size() == 1:
		winner_banner.set_winner(GameStorage.get_players()[winners[0]][0])

func update_winner():
	for p in players:
		if points[p] == max_points:
			player_points[p].set_winner(true)
			if slowness_mode:
				players[p].set("slowness", slowness)
		else:
			player_points[p].set_winner(false)
		

func _on_timer_timeout():
	game_duration -=1
	round_timer_text.set("text", "[center][color="+text_color+"]"+str(game_duration)+"[/color][/center]")
	
	for i in players:
		if players[i].has_object():
			points[i] += 1
			if points[i] >= max_points:
				max_points = points[i]
				update_winner()
			player_points[i].set_points(points[i])
			
	if game_duration <= 11:
		text_color = "#F00"
		animation_player.play("intense_timer")

	if game_duration <= 0:
		animation_player.stop()
		end_game()


func _on_audio_finished():
	$bgMusic.play()
