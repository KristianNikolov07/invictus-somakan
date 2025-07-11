extends Area2D
@export var start_pos : Marker2D

func _on_body_entered(body: Node2D) -> void:
	body.global_position = start_pos.global_position
