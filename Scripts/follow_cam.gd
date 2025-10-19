extends Camera2D

@export_category("Follow Target")
@export var follow: CharacterBody2D

@export_category("Camera Leading")
@export var x_lead_factor: float = 100.0
@export var y_lead_factor: float = 50.0
@export var max_lead_distance: Vector2 = Vector2(200, 100)

@export_category("Movement Smoothing")
@export var position_lerp_speed: float = 5.0
@export var min_position_lerp: float = 2.0
@export var max_position_lerp: float = 10.0

@export_category("Zoom Settings")
@export var zoom_dimensions: Vector2 = Vector2(1.0, 1.5)
@export var zoom_lerp_speed: float = 3.0
@export var min_zoom_lerp: float = 1.0
@export var max_zoom_lerp: float = 8.0
@export var high_speed: float = 500.0

@export_category("Advanced Tuning")
@export var enable_speed_based_lerp: bool = true
@export var dead_zone_radius: float = 50.0

var zoom_goal: Vector2
var speed_offset: Vector2 = Vector2.ZERO
var offset_goal: Vector2 = Vector2.ZERO

func _ready():
	# Initialize zoom goal
	zoom_goal = Vector2(zoom_dimensions.x, zoom_dimensions.x)

func set_follow(new_follow):
	follow = new_follow
	zoom_goal = Vector2(zoom_dimensions.x, zoom_dimensions.x)
	zoom = zoom_goal
	position = follow.global_position
	
func _process(delta):
	if not follow:
		return
	
	check_velocity()
	update_smoothing(delta)
	
	# Apply camera position with smoothing
	var target_position = follow.position + speed_offset
	position = position.lerp(target_position, get_position_lerp_factor(delta))
	
	# Apply zoom with smoothing
	zoom = zoom.lerp(zoom_goal, get_zoom_lerp_factor(delta))

func check_velocity():
	if not follow:
		return
	
	# Calculate lead offset based on velocity direction
	var velocity_normalized = follow.velocity.normalized() if follow.velocity.length() > 0 else Vector2.ZERO
	offset_goal = velocity_normalized
	
	# Calculate speed-based intensity (0 to 1)
	var speed_lerp = min(1.0, follow.velocity.length() / high_speed)
	
	# Apply factors and clamp to max lead distance
	offset_goal.x *= x_lead_factor * speed_lerp
	offset_goal.y *= y_lead_factor * speed_lerp
	
	# Clamp to maximum lead distance
	offset_goal.x = clamp(offset_goal.x, -max_lead_distance.x, max_lead_distance.x)
	offset_goal.y = clamp(offset_goal.y, -max_lead_distance.y, max_lead_distance.y)
	
	# Calculate zoom based on speed
	var z = lerp(zoom_dimensions.x, zoom_dimensions.y, speed_lerp)
	zoom_goal = Vector2(z, z)

func update_smoothing(delta):
	# Smoothly interpolate the speed offset
	var current_lerp_speed = position_lerp_speed
	if enable_speed_based_lerp:
		var speed_factor = min(1.0, follow.velocity.length() / high_speed)
		current_lerp_speed = lerp(min_position_lerp, max_position_lerp, speed_factor)
	
	speed_offset = speed_offset.lerp(offset_goal, current_lerp_speed * delta)

func get_position_lerp_factor(delta) -> float:
	# Convert lerp speed to a factor for the lerp function
	var base_lerp = position_lerp_speed * delta
	
	if enable_speed_based_lerp:
		var speed_factor = min(1.0, follow.velocity.length() / high_speed)
		var dynamic_speed = lerp(min_position_lerp, max_position_lerp, speed_factor)
		return dynamic_speed * delta
	
	return base_lerp

func get_zoom_lerp_factor(delta) -> float:
	# Convert zoom lerp speed to a factor
	var base_lerp = zoom_lerp_speed * delta
	
	if enable_speed_based_lerp:
		var speed_factor = min(1.0, follow.velocity.length() / high_speed)
		var dynamic_speed = lerp(min_zoom_lerp, max_zoom_lerp, speed_factor)
		return dynamic_speed * delta
	
	return base_lerp

# Optional: Add a dead zone so small movements don't affect camera much
func apply_dead_zone(offset: Vector2) -> Vector2:
	if offset.length() < dead_zone_radius:
		return Vector2.ZERO
	return offset
