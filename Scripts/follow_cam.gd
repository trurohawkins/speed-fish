extends Camera2D

@export var follow: CharacterBody2D
@export var xFactor: float
@export var yFactor: float
@export var lerp_move_speed: float = 20
@export var lerp_zoom_speed: float = 15 
@export var high_speed: float = 500
@export var zoom_dimensions: Vector2

var zoom_goal
var speed_offset: Vector2
var offset_goal: Vector2

func _process(delta):
	check_velocity()
	speed_offset = speed_offset.lerp(offset_goal, lerp_move_speed*delta)
	zoom = zoom.lerp(zoom_goal, lerp_zoom_speed*delta)
	position = follow.position + speed_offset
	
func check_velocity():
	offset_goal = Vector2(sign(follow.velocity.x), sign(follow.velocity.y))
	var speed_lerp = min(1, abs(follow.velocity.length()) / high_speed)

	offset_goal.x *= xFactor * speed_lerp
	offset_goal.y *= yFactor * speed_lerp
	var z = lerp(zoom_dimensions.x, zoom_dimensions.y, speed_lerp)
	zoom_goal = Vector2(z, z)
