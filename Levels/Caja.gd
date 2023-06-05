extends StaticBody2D

@export var velocity : float = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var hasCollided : bool = false
var onFloor : bool = false
var animationPlayed : String = "Idle"

func _physics_process(delta):
	velocity += gravity * delta
	if(!onFloor):
		var collision = move_and_collide(Vector2(0, velocity * delta))
		if collision:
			var colliderName = collision.get_collider().get_name()
			if(colliderName == "TileMap" or colliderName.begins_with("@Caja@") or colliderName.begins_with("Caja")):
				onFloor = true
			elif(colliderName == "Player" and !onFloor):
				collision.get_collider().aplastar()

func set_velocity(newVelocity: float):
	velocity = newVelocity

func get_velocity() -> float:
	return velocity



func _on_animated_sprite_2d_animation_finished():
	if(animationPlayed == "BottomHit"):
		animated_sprite.play("Idle")
