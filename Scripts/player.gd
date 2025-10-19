extends CharacterBody2D

@export var speed: int = 300
var facing_direction: Vector2 = Vector2.RIGHT

func _physics_process(delta):
	var movement = Vector2.ZERO
	
	# Map inputs directly to allowed directions
	if Input.is_key_pressed(KEY_A) and Input.is_key_pressed(KEY_W):
		movement = Vector2(-0.707, -0.707)  # Up-Left
		facing_direction = Vector2.LEFT
	elif Input.is_key_pressed(KEY_A) and Input.is_key_pressed(KEY_S):
		movement = Vector2(-0.707, 0.707)   # Down-Left
		facing_direction = Vector2.LEFT
	elif Input.is_key_pressed(KEY_D) and Input.is_key_pressed(KEY_W):
		movement = Vector2(0.707, -0.707)   # Up-Right
		facing_direction = Vector2.RIGHT
	elif Input.is_key_pressed(KEY_D) and Input.is_key_pressed(KEY_S):
		movement = Vector2(0.707, 0.707)    # Down-Right
		facing_direction = Vector2.RIGHT
	elif Input.is_key_pressed(KEY_A):
		movement = Vector2.LEFT              # Left
		facing_direction = Vector2.LEFT
	elif Input.is_key_pressed(KEY_D):
		movement = Vector2.RIGHT             # Right
		facing_direction = Vector2.RIGHT
	elif Input.is_key_pressed(KEY_W):
		if facing_direction == Vector2.RIGHT:
			movement = Vector2(0.707, -0.707)
		else:
			movement = Vector2(-0.707, -0.707)
	elif Input.is_key_pressed(KEY_S):
		if facing_direction == Vector2.RIGHT:
			movement = Vector2(0.707, 0.707)
		else:
			movement = Vector2(-0.707, 0.707)
	
	velocity = movement * speed
	move_and_slide()
