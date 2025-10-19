extends Node2D

@export var spawn_point: Vector2
@export var camera: Camera2D
@export var playerScene: PackedScene


func _ready() -> void:
	spawn_player()

func spawn_player():
	var player = playerScene.instantiate()
	player.global_position = spawn_point
	camera.set_follow(player)
	player.GM = self
	get_tree().current_scene.add_child(player)

func player_die(player):
	player.queue_free()
	spawn_player()
