extends Node2D


@onready var previews = [$CharPreview0, $CharPreview1, $CharPreview2, $CharPreview3]
@onready var timer = $charDeselectTimer
var lastDevice
signal player_select(player, selection)

func _ready():
	for n in Input.get_connected_joypads():
		if n < 4:
			player_select.emit(n, "no_character")


func _on_bg_animation_finished(anim_name): #seamless 😎 (kinda)
	if anim_name == "animated_bg":
		$AnimationPlayer.play(anim_name)


func _on_bg_music_finished():
	$bgMusic.play()

func on_cursor_entered(where: String, device: int):
	$CursorHandler.set_cursor_state(device, true)
	player_select.emit(device, where)
	lastDevice = device
	timer.stop()

	
func on_cursor_exited(where: String, device: int):
	$CursorHandler.set_cursor_state(device, false)
	timer.start()

func on_timeout():
	player_select.emit(lastDevice,"no_character")
