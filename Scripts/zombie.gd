extends Enemy

var direction = 1
var attacking = false


func _on_collision_damage_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		var knockback_dir = 1
		
		if body.global_position.x > global_position.x:
			knockback_dir = 1
		else:
			knockback_dir = -1
		
		if attacking:
			body.damage(attack_damage, knockback_strength * knockback_dir)
		else:
			body.damage(coll_damage, coll_knockback * knockback_dir)


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
	velocity.x = 2300 * direction
	attacking = true
	$Stagger.start()
	$Attack.start()

func _on_stagger_timeout() -> void:
	$AttackRange.set_collision_mask_value(1, true)
	set_is_moving(true)

func _on_attack_timeout() -> void:
	attacking = false
