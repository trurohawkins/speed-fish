extends CharacterBody2D
@export var speed: float = 100
var counter = 600

func _process(delta: float) -> void:
	velocity.x += speed * delta
	if abs(abs(velocity.x) - counter) < 5:
		speed *= -1
	move_and_slide()
