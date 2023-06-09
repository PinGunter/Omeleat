extends CharacterBody2D

@export var controller : int
@export var character : String
@export var has_crown: bool = false
@export var stomp_needs_press : bool = true
@export_range(0,200,10) var slowness : int = 0
signal stomped(me: int , enemy: int)


const SPEED : float = 200.0
const JUMP_VELOCITY : float = -300.0
const DOUBLE_JUMP_VELOCITY : float = -300.0
const WALL_SLIDE_ACCELERATION : float = 5.0
const MAX_WALL_SLIDE_SPEED : float = 100.0
const MAX_JUMPS : int = 2
const MAX_WALL_JUMPS : int = 3

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var down_rays : Array = [$DownRay,$DownRay2,$DownRay3]
@onready var stun_timer : Timer = $StunTimer
@onready var crown = $Tortilla1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps : int = MAX_JUMPS
var wall_jumps : int = MAX_WALL_JUMPS
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false
var current_animation : String = "idle"
var crashed : bool = false
var is_on_player : bool = false
var is_top_player: bool = false
var last_player_stomped: int
var stunned: bool = false



func is_colliding_close(ray : RayCast2D):
	if (ray.is_colliding()):
		last_player_stomped = ray.get_collider().get("controller")
		return (ray.get_collision_point().y - position.y) < 15.5
	return false

func is_colliding(ray : RayCast2D):
	return ray.is_colliding()


func _physics_process(delta):
	is_on_player = down_rays.any(is_colliding)
	is_top_player = down_rays.any(is_colliding_close)
	
	if is_on_player:
		if is_action_just_pressed("jump"):
			stomp()
		elif is_top_player:
			velocity.y = JUMP_VELOCITY * 0.7

	# Add the gravity.
	if not is_on_floor() : # air
		velocity.y += gravity * delta
		was_in_air = true

		if(velocity.y > 0):
			fall()
		if is_on_wall():
			if is_action_pressed("left") or is_action_pressed("right"):
				wall_slide(delta)
			if is_action_just_pressed("jump") and wall_jumps > 0:
				wall_jump()
		else:
			if is_on_player and (not stomp_needs_press or ( stomp_needs_press and is_action_just_pressed("jump"))):
				stomp()
			elif is_action_just_pressed("jump") and jumps > 0:
				double_jump()

	else: #floor
		jumps = MAX_JUMPS
		wall_jumps = MAX_WALL_JUMPS
		was_in_air = false
			
		if velocity.x == 0:
			current_animation = "idle"
		else:
			current_animation = "run"
			
		if is_action_just_pressed("jump") and not is_on_player:
			jump()


			

		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = get_vector("left", "right", "up", "down")
	
	if crashed:
		velocity.x = 0
	elif direction:
		velocity.x = direction.x * (SPEED - slowness)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

	

	is_on_floor()

	move_and_slide()
	update_animation()
	update_facing_direction()
	
func update_animation():
	animated_sprite.play(character + "_" + current_animation)
			
func update_facing_direction():
	if direction.x < 0:
		animated_sprite.flip_h = true
	elif direction.x > 0:
		animated_sprite.flip_h = false

func jump():
	velocity.y = JUMP_VELOCITY 
	jumps -= 1
	current_animation = "jump"

func double_jump():
	velocity.y = DOUBLE_JUMP_VELOCITY
	current_animation = "doubleJump"
	jumps -= 1

func wall_jump():
	velocity.y = DOUBLE_JUMP_VELOCITY
	current_animation = "doubleJump"
	wall_jumps -= 1

func wall_slide(delta : float):
	if velocity.y >= 0:
		velocity.y = min(velocity.y + WALL_SLIDE_ACCELERATION, MAX_WALL_SLIDE_SPEED)
		current_animation = "wallSlide"
	else:
		velocity.y += gravity * delta

func fall():
	current_animation = "fall"

func aplastar():
	self.set_scale(Vector2(1.0, 0.1))
	velocity.x = 0
	crashed = true
	queue_free()


func nextToWall():
	return nextToRightWall() or nextToLeftWall()

func nextToRightWall():
	return $RightWall.is_colliding()

func nextToLeftWall():
	return $LeftWall.is_colliding()
	
func is_action_just_pressed(action : String):
	return Input.is_action_just_pressed(action+"_"+str(controller))

func is_action_pressed(action : String):
	return Input.is_action_pressed(action+"_"+str(controller))

func get_vector(negative_x: String, positive_x: String, negative_y: String, positive_y: String):
	return Input.get_vector(negative_x+"_"+str(controller),positive_x+"_"+str(controller), negative_y+"_"+str(controller), positive_y+"_"+str(controller))

func stomp():
	print("Stomping")
	velocity.y = JUMP_VELOCITY * 1.35
	stomped.emit(controller, last_player_stomped)

func get_stomped():
	print(character + " is now stomped")
	stun_timer.start()
	scale.y = 0.7
	stunned = true
		
func _on_stun_timer_timeout():
	scale.y = 1
	stunned = false

func receive_crown():
	has_crown = true
	crown.visible = true

func lose_crown():
	has_crown = false
	crown.visible = false
	
func has_object():
	return has_crown
