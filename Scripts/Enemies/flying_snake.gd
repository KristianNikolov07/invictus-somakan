extends FlyingEnemy

func _process(delta: float) -> void:
	$Sprite2D.look_at(target.global_position)

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") and not is_frozen() and not is_frostbitten() and not is_blizzard():
		var knockback_dir = calculate_direction(body)
		var parry_time_left = body.check_parry(self)
		print(parry_time_left)
		if parry_time_left > body.get_parry_time() / 1.2:
			damage_amount(parry_damage, parry_knockback_mult)
			body.stop_parry()
		elif parry_time_left > 0:
			damage_amount(parry_damage, parry_knockback_mult)
			body.stop_parry()
			body.damage_amount(attack_damage / 3, (knockback_strength * knockback_dir) / 3)
		else:
			body.damage_amount(attack_damage, knockback_strength * knockback_dir)


func calculate_direction(body):
	var knockback_dir = 1
	if body.global_position.x > global_position.x:
		knockback_dir = 1
	else:
		knockback_dir = -1
	return knockback_dir
