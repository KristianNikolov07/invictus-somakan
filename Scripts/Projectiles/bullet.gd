extends Projectile


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies") and can_hit_enemies:
		body.damage_amount(damage, knockback)
		queue_free()
	elif not body.is_in_group("Players"):
		queue_free()
