extends Hitbox

func _on_hit_cooldown_timeout() -> void:
	if get_parent().is_damageing:
		for body in get_overlapping_bodies():
			if body.has_method("damage") and body.is_in_group("Enemies"):
				var aspect: AspectItem = get_parent().get_aspect_to_apply()
				if aspect != null:
					aspect.apply_crit_stats(get_node("."))
				body.damage(get_node("."), 0)
				if aspect != null:
					aspect.unapply_crit_stats(get_node("."))
					aspect.apply_effect(body)


func _on_duration_timeout() -> void:
	get_parent().is_damageing = false
	$Sprite2D.hide()
