extends CharacterBody2D

@export var speed: int = 300
@export var acceleration: float = 10
@export var top_speed: int = 2000
@export var friction: float = 80
@export var crash_limit: float = 400
var GM

var facing_direction: Vector2 = Vector2.RIGHT
var current_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
	var input_direction = Vector2.ZERO
	
	# Map inputs directly to allowed directions
	if Input.is_key_pressed(KEY_A) and Input.is_key_pressed(KEY_W):
		input_direction = Vector2(-0.707, -0.707)  # Up-Left
		facing_direction = Vector2.LEFT
	elif Input.is_key_pressed(KEY_A) and Input.is_key_pressed(KEY_S):
		input_direction = Vector2(-0.707, 0.707)   # Down-Left
		facing_direction = Vector2.LEFT
	elif Input.is_key_pressed(KEY_D) and Input.is_key_pressed(KEY_W):
		input_direction = Vector2(0.707, -0.707)   # Up-Right
		facing_direction = Vector2.RIGHT
	elif Input.is_key_pressed(KEY_D) and Input.is_key_pressed(KEY_S):
		input_direction = Vector2(0.707, 0.707)    # Down-Right
		facing_direction = Vector2.RIGHT
	elif Input.is_key_pressed(KEY_A):
		input_direction = Vector2.LEFT              # Left
		facing_direction = Vector2.LEFT
	elif Input.is_key_pressed(KEY_D):
		input_direction = Vector2.RIGHT             # Right
		facing_direction = Vector2.RIGHT
	elif Input.is_key_pressed(KEY_W):
		if facing_direction == Vector2.RIGHT:
			input_direction = Vector2(0.707, -0.707)
		else:
			input_direction = Vector2(-0.707, -0.707)
	elif Input.is_key_pressed(KEY_S):
		if facing_direction == Vector2.RIGHT:
			input_direction = Vector2(0.707, 0.707)
		else:
			input_direction = Vector2(-0.707, 0.707)
	
	# Calculate target velocity
	var target_velocity = input_direction * top_speed
	
	# Apply acceleration or friction
	if input_direction != Vector2.ZERO:
		# Check if we're reversing direction (moving opposite to input)
		var is_reversing = current_velocity.length() > 0 and current_velocity.dot(input_direction) < 0
		
		# Use different acceleration values for normal vs reversing
		var current_acceleration = acceleration * 0.5 if is_reversing else acceleration
		
		# Accelerate toward target velocity
		#current_velocity = current_velocity.move_toward(target_velocity, current_acceleration * delta * 60)
		velocity = velocity.move_toward(target_velocity, current_acceleration * delta * 60)
	else:
		# Apply friction when no input
		#current_velocity = current_velocity.move_toward(Vector2.ZERO, friction * delta * 60)
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta * 60)
	#changed to velocity instead of current_velocity, because now when we move_and_slide into an obstacle
	#the velocity is changed
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		if velocity.length() > crash_limit:
			GM.player_die(self)
