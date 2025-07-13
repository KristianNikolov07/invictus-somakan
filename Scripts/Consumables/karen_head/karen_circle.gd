extends Area2D
@export var damage = 0
@export var knockback = 1.5

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies") and body.has_method("damage_amount"):
		if body.global_position.x < global_position.x:
			body.damage_amount.rpc(damage, -1 * knockback)
		else:
			body.damage_amount.rpc(damage, knockback)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
