extends CharacterBody2D

@export var controller : int
@export var character : String

const SPEED : float = 200.0
const JUMP_VELOCITY : float = -300.0
const DOUBLE_JUMP_VELOCITY : float = -300.0
const WALL_SLIDE_ACCELERATION : float = 5.0
const MAX_WALL_SLIDE_SPEED : float = 100.0
const MAX_JUMPS : int = 2
const MAX_WALL_JUMPS : int = 1

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps : int = MAX_JUMPS
var wall_jumps : int = MAX_WALL_JUMPS
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false
var current_animation : String = "idle"
@onready var down_rays : Array = [$DownRay,$DownRay2,$DownRay3]

func _physics_process(delta):
	
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
			if is_action_just_pressed("jump") and jumps > 0:
				double_jump()

	else: #floor
		jumps = MAX_JUMPS
		wall_jumps = MAX_WALL_JUMPS
		was_in_air = false
			
		if velocity.x == 0:
			current_animation = "idle"
		else:
			current_animation = "run"
			
		if is_action_just_pressed("jump"):
			jump()
			

		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = get_vector("left", "right", "up", "down")
	
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

	for ray in down_rays:
		if ray.is_colliding():
			print("Colisionando con " + ray.get_collider().get("name"))

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
