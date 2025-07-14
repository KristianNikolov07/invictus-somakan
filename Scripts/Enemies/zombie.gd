extends WalkingEnemy

var direction = 1

func _process(delta: float) -> void:
	if $Sprite.animation == "walking" or $Sprite.animation == "default" or $Sprite.animation == "falling":
		if velocity.y > 0:
			$Sprite.play("falling")
		elif velocity.x == 0:
			$Sprite.play("default")
		elif velocity.x > 0:
			$Sprite.flip_h = true
			$Sprite.play("walking")
		elif velocity.x < 0:
			$Sprite.flip_h = false
			$Sprite.play("walking")

func death():
	$Sprite.play("death")
	speed = 0
	for child in get_children():
		if child.name != "Sprite" and child.name != "Collision":
			child.queue_free()

func calculate_direction(body):
	var knockback_dir = 1
	if body.global_position.x > global_position.x:
		knockback_dir = 1
	else:
		knockback_dir = -1
	return knockback_dir

func _on_collision_damage_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") and not is_frozen() and not is_frostbitten() and not is_blizzard():
		var knockback_dir = calculate_direction(body)
		if not attacking:
			body.damage_amount(coll_damage, coll_knockback * knockback_dir)

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") and not is_frozen() and not is_frostbitten() and not is_blizzard():
		$AttackRange.set_collision_mask_value(1, false)
		$Sprite.play("attack-charge")
		$AttackCharge.start()
		set_is_moving(false)
		if body.global_position.x < global_position.x:
			direction = -1
		else:
			direction = 1

func _on_attack_charge_timeout() -> void:
	if not is_frozen() and not is_frostbitten() and not is_blizzard():
		velocity.x = 2200 * direction
		attacking = true
		$Stagger.start()
		$Attack.start()
		$AttackHitbox.set_collision_mask_value(1, true)
		$Sprite.play("attack")


func _on_stagger_timeout() -> void:
	$AttackRange.set_collision_mask_value(1, true)
	if not is_frozen() and not is_frostbitten() and not is_blizzard():
		set_is_moving(true)
		$Sprite.play("walking")

func _on_attack_timeout() -> void:
	$AttackHitbox.set_collision_mask_value(1, false)
	attacking = false

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		var knockback_dir = calculate_direction(body)
		var parry_time_left = body.check_parry(self)
		print(parry_time_left)
		if parry_time_left > body.get_parry_time() / 1.2:
			$Hitstop.start()
			body.begin_hitstop()
			damage_amount(max_hp, parry_knockback_mult)
			body.stop_parry()
		elif parry_time_left > 0:
			$Hitstop.start()
			body.begin_hitstop()
			parry(body)
			body.stop_parry()
			body.damage_amount((attack_damage / 3) * damage_mult, (knockback_strength * knockback_dir) / 3)
		else:
			body.damage_amount((attack_damage) * damage_mult, knockback_strength * knockback_dir)

func damage_anim():
	$Sprite.play("damage")

func _on_sprite_animation_finished() -> void:
	if $Sprite.animation == "damage":
		$Sprite.play("default")
	if $Sprite.animation == "death":
		super.death()
