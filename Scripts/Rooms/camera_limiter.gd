extends Node

@export var limit_up: int
@export var limit_down: int
@export var limit_left: int
@export var limit_right: int

func _ready() -> void:
	for player in get_tree().get_nodes_in_group("Players"):
		player.get_node("Camera2D").limit_left = limit_left
		player.get_node("Camera2D").limit_right = limit_right
		player.get_node("Camera2D").limit_top = limit_up
		player.get_node("Camera2D").limit_bottom = limit_down
