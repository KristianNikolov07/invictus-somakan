extends Projectile


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") and can_hit_players:
		var knockback_dir = calculate_direction(body)
		var parry_time_left = body.check_parry(self)
		print(parry_time_left)
		if parry_time_left > 0 and can_be_parried:
			$Hitstop.start()
			body.begin_hitstop()
			call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED)
			
			var is_perfect = parry_time_left > body.get_parry_time() / 1.2
			body.stop_parry()
			if not is_perfect and times_parried <= 1:
				body.damage_amount(damage / 3, knockback / 3)
				times_parried += 1
				damage += floor(damage / 2)
				speed += speed / 2
				knockback += knockback/10
			else:
				can_be_parried = false
				knockback += knockback/6
				speed *= 3
				damage += damage*2
			
			can_hit_enemies = true
			rotation_degrees += 180
		else:
			body.damage_amount(damage, knockback * knockback_dir)
			if applied_aspect != null:
				applied_aspect.apply_effect(body)
			queue_free()
		
	elif body.is_in_group("Enemies") and can_hit_enemies:
		body.damage_amount(damage, knockback)
		if applied_aspect != null:
			applied_aspect.apply_effect(body)
		queue_free()
	elif not body.is_in_group("Players") and not body.is_in_group("Enemies"):
		queue_free()


func _on_hitstop_timeout() -> void:
	call_deferred("set_process_mode", Node.PROCESS_MODE_INHERIT)
