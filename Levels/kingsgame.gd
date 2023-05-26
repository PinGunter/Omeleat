extends Node2D

@export var game_duration : int = 60;

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
@onready var point_banners = {0: $points/p1, 1: $points/p2, 2: $points/p3, 3: $points/p4}
@onready var winner_icons = {0: $points/p1/winner, 1: $points/p2/winner, 2: $points/p3/winner, 3: $points/p4/winner}
@onready var points_text = {0:$points/p1/point, 1:  $points/p2/point, 2: $points/p3/point, 3: $points/p4/point}
@onready var animation_player = $AnimationPlayer

var players = {}
var points = {0: 0, 1: 0, 2: 0, 3:0}
var max_points = 0
var text_color = "#000"

func _ready():
	player_manager.instantiate_players(positions)
	players = player_manager.get_players()
	for p in players:
		players[p].stomped.connect(on_stomped)
		point_banners[p].visible = true
	

func on_stomped(who: int, enemy : int): # depending on the level it works in one way or another (exchanging crown for example)
	if players[enemy].get("has_crown"):
		players[enemy].lose_crown()
		players[who].receive_crown()
	screen_shaker.shake()
	players[enemy].get_stomped()


func _on_tortilla_entered(body):
	if body.is_in_group("players"):
		body.receive_crown()
		$Tortilla1.queue_free()

func end_game():
	print("Player 0: " + str(points[0]))
	print("Player 1: " + str(points[1]))
	timer.stop()
	round_timer_text.set("text", "[center] GAME OVER [/center]")

func update_winner():
	for p in winner_icons:
		if points[p] == max_points:
			winner_icons[p].visible = true
		else:
			winner_icons[p].visible = false
		

func _on_timer_timeout():
	game_duration -=1
	round_timer_text.set("text", "[center][color="+text_color+"]"+str(game_duration)+"[/color][/center]")
	
	for i in players:
		if players[i].has_object():
			points[i] += 1
			if points[i] >= max_points:
				max_points = points[i]
				update_winner()
			points_text[i].set("text", points[i])
			
	if game_duration <= 11:
		text_color = "#F00"
		animation_player.play("intense_timer")

	if game_duration <= 0:
		animation_player.stop()
		end_game()
