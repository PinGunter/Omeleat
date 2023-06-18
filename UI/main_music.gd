extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	if ConfigLoader.get_config()["volume"] == 0:
		$bgMusic.volume_db = -80
	else:
		$bgMusic.volume_db = (1 - ConfigLoader.get_config()["volume"]) * -40


func play():
	$bgMusic.play()
	
func stop():
	$bgMusic.stop()
