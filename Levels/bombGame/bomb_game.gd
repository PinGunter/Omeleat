extends Node2D
@export var game_duration : int = 0;
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
@onready var end_timer = $roundEndTimer

var slowness = 50
var players = {}
var text_color = "#000"
var player_points_scene = preload("res://UI/player_points.tscn")
var player_points = {}
var bomb_timers = {}
var player_positions = {}
var last_position = 0
var winnerName = null
var winnerId = null

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
		player_positions[p] = pl_p
		i += 1
	
	var num_players = players.size() 
	
	if(num_players == 2):
		bomb_timers.push(20)
		game_duration = 20
	elif(num_players == 3):
		bomb_timers.push(30)
		bomb_timers.push(15)
		game_duration = 30
	else:
		bomb_timers.push(30)
		bomb_timers.push(20)
		bomb_timers.push(10)
		game_duration = 30

func on_stomped(who: int, enemy : int): # depending on the level it works in one way or another (exchanging crown for example)
	if !players[enemy].get("has_bomb"):
		players[enemy].receive_bomb()
		players[who].lose_bomb()
		screen_shaker.shake()
		$pickup.play()
		if slowness_mode:
			players[enemy].set("slowness", 0)
			players[who].set("slowness", slowness)
	players[enemy].get_stomped()
	

func _on_tortilla_entered(body):
	if body.is_in_group("players"):
		$pickup.play()
		body.receive_crown()
		if slowness_mode:
			body.set("slowness", slowness)
		$Tortilla1.queue_free()

func end_game():
	winner_banner.z_index = 999
	winner_banner.set_winner(winnerName)
	GameStorage.update_points(winnerId,GameStorage.get_player_points(winnerId)+1)
	end_timer.start()
		

		

func _on_timer_timeout():
	game_duration -=1
	round_timer_text.set("text", "[center][color="+text_color+"]"+str(game_duration)+"[/color][/center]")

			
	if game_duration <= 11:
		text_color = "#F00"
		animation_player.play("intense_timer")

	if game_duration <= 0:
		animation_player.stop()
		end_game()
		

func explode_player(player : int):
	players[player].explode()
	var clasificated = null
	if last_position == 4:
		clasificated = "4th"
	elif last_position == 3:
		clasificated = "3rd"
	elif last_position == 2:
		clasificated = "2nd"
	else: clasificated = "1st"

	player_positions[player].set_points_string(clasificated)
	last_position -= 1
	
	if last_position == 1:
		var players_alive = get_tree().get_nodes_in_group("players")
		for p in players_alive:
			if p.get("controller") != player:
				winnerId = p.get("controller")
				winnerName = p.get("character")
		player_positions[winnerId].set_points_string("1st")
		end_game()


func _on_audio_finished():
	$bgMusic.play()


func _on_round_timer_end():
	SceneTransition.change_scene("res://Levels/post_round.tscn")
