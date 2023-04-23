extends CharacterBody2D


const SPEED : float = 200.0
const JUMP_VELOCITY : float = -400.0
const DOUBLE_JUMP_VELOCITY : float = -300.0
const WALL_SLIDE_ACCELERATION : float = 10.0
const MAX_WALL_SLIDE_SPEED : float = 200.0
const WALL_JUMP_DISTANCE : float = 500.0
const WALL_JUMP : float = 200.0

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false
var is_wall_jumping : bool = false



func _physics_process(delta):
	
	is_wall_jumping = false
	
	# Add the gravity.
	if not is_on_floor() :
		velocity.y += gravity * delta
		was_in_air = true
		if(velocity.y > 0):
			land()
	else:
		has_double_jumped = false
		was_in_air = false
		animation_locked = false

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			# Normal jump from floor
			jump()
		elif not is_on_floor() && nextToRightWall() :
			
			
			# Normal jump from right wall
			velocity.x = -10 
			velocity.y = -1000
			
			is_wall_jumping = true
		elif not is_on_floor() && nextToLeftWall() :
			print(gravity)
			print("Salto de pared")
			print(velocity.x)
			print(velocity.y)
			# Normal jump from left wall
			velocity.x = 1000 * delta
			velocity.y = -400 * delta
			
			is_wall_jumping = true
			
			print(velocity.x)
			print(velocity.y)
		elif not has_double_jumped:
			# Double jump in air
			double_jump()
		
			
	# Handle WallJump
	#if is_on_wall():
	# if is_on_wall() && (Input.is_action_pressed("right") || Input.is_action_pressed("left")):
	#	wall_slide()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")
	
	if direction:
		velocity.x = direction.x * SPEED
	elif not is_wall_jumping:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

	move_and_slide()
	update_animation()
	update_facing_direction()
	
func update_animation():
	if not animation_locked:
		if direction.x != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
			
func update_facing_direction():
	if nextToWall() && Input.is_action_just_pressed("jump") && not Input.is_action_pressed("up"):
		if nextToLeftWall():
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	elif direction.x < 0:
		animated_sprite.flip_h = true
	elif direction.x > 0:
		animated_sprite.flip_h = false

func jump():
	velocity.y = JUMP_VELOCITY 
	animated_sprite.play("jump")
	animation_locked = true

func double_jump():
	velocity.y = DOUBLE_JUMP_VELOCITY
	animated_sprite.play("doubleJump")
	animation_locked = true
	has_double_jumped = true

func wall_slide():
	if velocity.y >= 0:
		velocity.y = min(velocity.y + WALL_SLIDE_ACCELERATION, MAX_WALL_SLIDE_SPEED)
		animated_sprite.play("wallJump")
	else:
		velocity.y += gravity
	print("velocidad en y")
	print(velocity.y)
	animation_locked = true
	has_double_jumped = false

func land():
	animated_sprite.play("fall")
	animation_locked = true

func nextToWall():
	return nextToRightWall() or nextToLeftWall()

func nextToRightWall():
	return $RightWall.is_colliding()

func nextToLeftWall():
	return $LeftWall.is_colliding()

