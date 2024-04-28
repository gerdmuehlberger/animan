extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 50.0

var jump_buffer_time = 20
var jump_buffer_count = 0
var cayote_time = 60
var cayote_count = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if cayote_count > 0:
			cayote_count -= 1
			
		velocity.y += gravity * delta

	elif is_on_floor():
		cayote_count = cayote_time

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump_buffer_count = jump_buffer_time
		
	if jump_buffer_count > 0:
		jump_buffer_count -= 1
	
	if jump_buffer_count > 0 and cayote_count > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_count = 0
		cayote_count = 0
	
		
	if Input.is_action_just_released("ui_accept"):
		if velocity.y < 0:
			velocity.y += 200.0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
