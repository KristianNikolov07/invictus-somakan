extends Area2D
@export var damage_amount = 20

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("damage") and !body.is_in_group("Players"):
		body.damage_amount(damage_amount, 0)


func _on_destroy_timer_timeout() -> void:
	queue_free()
