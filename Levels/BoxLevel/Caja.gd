extends StaticBody2D

@export var velocity : float = 2
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 100
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var hasCollided : bool = false
var onFloor : bool = false
var animationPlayed : String = "Idle"
signal smash(player : int) 



func _physics_process(delta):
	velocity += gravity * delta
	if(!onFloor):
		var collision = move_and_collide(Vector2(0, velocity * delta))
		if collision:
			var colliderName = collision.get_collider().get_name()
			if(colliderName == "TileMap" or colliderName.begins_with("@Caja@") or colliderName.begins_with("Caja")):
				onFloor = true
				$smashBox.play()
			elif(collision.get_collider().is_in_group("players") and !onFloor):
				smash.emit(collision.get_collider().get("controller"))
				$muerte.play()
				

func set_gravity(newGravity: float):
	gravity = newGravity

func get_gravity() -> float:
	return gravity



func _on_animated_sprite_2d_animation_finished():
	if(animationPlayed == "BottomHit"):
		animated_sprite.play("Idle")
