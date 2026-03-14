extends CharacterBody2D

@export var acceleration: float = 500
@export var top_speed: int = 1000
@export var friction: float = 200
@export var buoyancy_speed: float = 100
@export var crash_limit: float = 400
var GM

var facing_direction: Vector2 = Vector2.RIGHT
var current_velocity: Vector2 = Vector2.ZERO
var current_speed: float = 0.0

func _physics_process(delta):
	var input_direction = Vector2.ZERO
	
	# Map inputs directly to allowed directions
	if Input.is_key_pressed(KEY_A) and Input.is_key_pressed(KEY_W):
		input_direction = Vector2(-0.75, -0.75)  # Up-Left
		facing_direction = Vector2.LEFT
	elif Input.is_key_pressed(KEY_A) and Input.is_key_pressed(KEY_S):
		input_direction = Vector2(-0.75, 0.75)   # Down-Left
		facing_direction = Vector2.LEFT
	elif Input.is_key_pressed(KEY_D) and Input.is_key_pressed(KEY_W):
		input_direction = Vector2(0.75, -0.75)   # Up-Right
		facing_direction = Vector2.RIGHT
	elif Input.is_key_pressed(KEY_D) and Input.is_key_pressed(KEY_S):
		input_direction = Vector2(0.75, 0.75)    # Down-Right
		facing_direction = Vector2.RIGHT
	elif Input.is_key_pressed(KEY_A):
		input_direction = Vector2.LEFT              # Left
		facing_direction = Vector2.LEFT
	elif Input.is_key_pressed(KEY_D):
		input_direction = Vector2.RIGHT             # Right
		facing_direction = Vector2.RIGHT
	elif Input.is_key_pressed(KEY_W):
		if facing_direction == Vector2.RIGHT:
			input_direction = Vector2(0.75, -0.75)
		else:
			input_direction = Vector2(-0.75, -0.75)
	elif Input.is_key_pressed(KEY_S):
		if facing_direction == Vector2.RIGHT:
			input_direction = Vector2(0.75, 0.75)
		else:
			input_direction = Vector2(-0.75, 0.75)
	
	if velocity.x > 0 and input_direction.x < 0:
		if current_speed < 0:
			current_speed = 0
		if current_speed > acceleration:
			input_direction.x = 0
	if velocity.x < 0 and input_direction.x > 0:
		current_speed -= acceleration
		if current_speed < 0:
			current_speed = 0
		if current_speed > acceleration:
			input_direction.x = 0
	
	# Apply acceleration or friction
	if input_direction != Vector2.ZERO:
		current_speed += acceleration * delta
		if current_speed >= top_speed:
			current_speed = top_speed
		velocity = input_direction * current_speed
	else:
		current_speed -= friction
		if current_speed < 0:
			current_speed = 0

	buoyancy(delta)
	current_velocity = velocity

	move_and_slide()
	check_collisions()	

func check_collisions():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() is TileMapLayer:
			#should check direction too
			if current_velocity.length() > crash_limit:
				GM.player_die(self)
				break

func buoyancy(delta):
	if abs(global_position.y) > buoyancy_speed * delta:
		var dir = -sign(global_position.y)
		var buoy_drift = Vector2(0, dir * buoyancy_speed * delta)
		velocity += buoy_drift
