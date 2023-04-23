extends Node2D

@export var rounds : int = 5
@onready var rounds_text = 5

@onready var previews = [$CharPreview0, $CharPreview1, $CharPreview2, $CharPreview3]
@onready var timer = $charDeselectTimer

var lastDevice
signal player_select(player, selection)
var no_character = "no_character"
var froggy = "froggy"
var wilding = "wilding"
var pink_guy = "pink_guy"
var very_real = "very_real"

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
	# check character frames
	for f in frames:
		if f.get("name") == where:
			f.select(device)
			player_select.emit(device,where)
			player_chosen[device] = where
		elif f.get("player") == device:
			f.deselect()
	# check buttons
	var buttons = get_tree().get_nodes_in_group("buttons")
	for b in buttons:
		if b.get("name") == where:
			b.launch_action()


func _on_button_action(what):
	if what == "back":
		SceneTransition.change_scene("res://UI/main_menu.tscn")
