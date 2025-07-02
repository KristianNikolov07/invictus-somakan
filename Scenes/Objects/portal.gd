extends Area2D
@export var room : PackedScene


func interact():
	get_tree().change_scene_to_packed(room)
