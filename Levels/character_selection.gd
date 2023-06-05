extends Node2D

@export var rounds : int = 5
	

@onready var previews = [$CharPreview0, $CharPreview1, $CharPreview2, $CharPreview3]
@onready var timer = $charDeselectTimer
@onready var rounds_text = $roundSelection/tortillas
@onready var next_btn = $nextButton

var lastDevice
signal player_select(player, selection)
var no_character = "no_character"
var froggy = "froggy"
var wilding = "wilding"
var pink_guy = "pink_guy"
var very_real = "very_real"
var base_sound = -40;

var player_chosen = {
	0: no_character,
	1: no_character,
	2: no_character,
	3: no_character
}


func _ready():
	for n in Input.get_connected_joypads():
		if n < 4:
			player_select.emit(n, no_character)
	if ConfigLoader.get_config()["volume"] == 0:
		$bgMusic.volume_db = -80
	else:
		$bgMusic.volume_db = (1 - ConfigLoader.get_config()["volume"]) * base_sound
	update_rounds_text(rounds)

func _input(event):
	for n in range(4):
		if event.is_action_pressed("back_"+str(n)):
			player_select.emit(n,no_character)
			player_chosen[n] = no_character
			print(player_chosen)

func _on_bg_animation_finished(anim_name): #seamless 😎 (kinda)
	if anim_name == "animated_bg":
		$AnimationPlayer.play(anim_name)


func _on_bg_music_finished():
	$bgMusic.play()

func on_cursor_entered(where: String, device: int):
	$CursorHandler.set_cursor_state(device, where, true)
	if player_chosen[device] == no_character:
		player_select.emit(device, where)
		timer.stop()

	
func on_cursor_exited(where: String, device: int):
	$CursorHandler.set_cursor_state(device, where, false)
	if player_chosen[device] == no_character:
		lastDevice = device
		timer.start()

func on_button_entered(where: String, device : int):
	$CursorHandler.set_cursor_state(device, where, true)
	
func on_button_exited(where: String, device : int):
	$CursorHandler.set_cursor_state(device, where, false)

func on_timeout():
	if player_chosen[lastDevice] == no_character:
		player_select.emit(lastDevice,no_character)


func on_cursor_clicked(device, where):
	var frames = get_node("frames").get_children()
	var frame_names = frames.map(func(f): return f.get("name"))
	# check character frames
	if where in frame_names:
		for f in frames:
			if f.get("name") == where:
				f.select(device)
				player_select.emit(device,where)
				player_chosen[device] = where
			elif f.get("player") == device:
				f.deselect()
				
	if (check_selected() >= 1):
		next_btn.visible = true
	else:
		next_btn.visible = false
	
	# check buttons
	var buttons = get_tree().get_nodes_in_group("buttons")
	for b in buttons:
		if b.get("name") == where:
			b.launch_action()


func update_global_selection():
	for p in player_chosen:
		GameStorage.update_player(p,player_chosen[p])
		

func _on_button_action(what):
	if what == "back":
		SceneTransition.change_scene("res://UI/main_menu.tscn")
	elif what == "next":
		update_global_selection()
		if GameStorage.get_active_players().size() >= 1:
			SceneTransition.change_scene("res://Levels/BoxLevel.tscn")
	elif what == "removeRounds":
		rounds = max(1,rounds-1)
		update_rounds_text(rounds)
	elif what == "addRounds":
		rounds = min(10,rounds+1)
		update_rounds_text(rounds)

func update_rounds_text(r : int):
	rounds_text.set("text", "[center]%s[/center]" % r)
	if r == 10:
		$roundSelection/rightButton.visible = false
		$roundSelection/rightButton.force_exit() # no se si dejarlo o no :)
	else:
		$roundSelection/rightButton.visible = true
	if r == 1:
		$roundSelection/leftButton.visible = false
		$roundSelection/leftButton.force_exit()
	else:
		$roundSelection/leftButton.visible = true

func check_selected() -> int:
	var selected = 0
	for p in player_chosen:
		if player_chosen[p] != no_character:
			selected += 1
	return selected
