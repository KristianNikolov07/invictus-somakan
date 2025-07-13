extends Projectile

var already_hit := false


func _on_body_entered(body: Node2D) -> void:
	if not already_hit:
		if body.is_in_group("Enemies") and can_hit_enemies:
			already_hit = true
			body.damage_amount(damage, knockback)
      if applied_aspect != null:
			  applied_aspect.apply_effect(body)
			queue_free()
		elif not body.is_in_group("Players"):
			queue_free()
