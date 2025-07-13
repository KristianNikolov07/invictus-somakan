extends Area2D

@export var start_pos : Marker2D
@export var damage_percent: float = 0.2


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		body.damage_amount(PlayerStats.max_hp*0.2, 0)
	body.global_position = start_pos.global_position
