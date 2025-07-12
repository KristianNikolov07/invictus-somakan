extends Node

func _ready() -> void:
	for player in get_tree().get_nodes_in_group("Players"):
		player.get_node("Camera2D").limit_left = get_parent().get_node("BorderLeft").global_position.x
		player.get_node("Camera2D").limit_right = get_parent().get_node("BorderRight").global_position.x
		player.get_node("Camera2D").limit_top = get_parent().get_node("Roof").global_position.y
		player.get_node("Camera2D").limit_bottom = 0
