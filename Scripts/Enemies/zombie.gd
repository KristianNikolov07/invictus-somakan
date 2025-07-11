extends WalkingEnemy

var direction = 1

func calculate_direction(body):
	var knockback_dir = 1
	if body.global_position.x > global_position.x:
		knockback_dir = 1
	else:
		knockback_dir = -1
	return knockback_dir

func _on_collision_damage_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		var knockback_dir = calculate_direction(body)
		if not attacking:
			body.damage_amount(coll_damage, coll_knockback * knockback_dir)

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		$AttackRange.set_collision_mask_value(1, false)
		$AttackCharge.start()
		set_is_moving(false)
		if body.global_position.x < global_position.x:
			direction = -1
		else:
			direction = 1

func _on_attack_charge_timeout() -> void:
	velocity.x = 1200 * direction
	attacking = true
	$Stagger.start()
	$Attack.start()
	$AttackHitbox.set_collision_mask_value(1, true)

func _on_stagger_timeout() -> void:
	$AttackRange.set_collision_mask_value(1, true)
	set_is_moving(true)

func _on_attack_timeout() -> void:
	$AttackHitbox.set_collision_mask_value(1, false)
	attacking = false

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
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
