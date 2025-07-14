extends WalkingEnemy

var direction = 1
var arrow := preload("res://Scenes/Projectiles/arrow.tscn")

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

func damage_anim():
	$Sprite.play("damage")

func _on_sprite_animation_finished() -> void:
	if $Sprite.animation == "damage":
		$Sprite.play("default")
	if $Sprite.animation == "death":
		super.death()

func fire_arrow() -> void:
	var new_arrow: Projectile = arrow.instantiate()
	new_arrow.global_position = global_position
	new_arrow.rotation = global_position.direction_to(target.global_position).angle()
	new_arrow.shooter_vel = velocity
	new_arrow.can_hit_enemies = false
	get_tree().current_scene.add_child(new_arrow)

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
		set_is_moving(false)
		if $AttackCharge.is_stopped() and $AttackCool.is_stopped():
			$AttackCharge.start()

func _on_attack_range_body_exited(body: Node2D) -> void:
	if target != null and body == target:
		if not $AttackCharge.is_stopped():
			await $AttackCharge.timeout
		
		set_is_moving(true)


func _on_attack_charge_timeout() -> void:
	if not is_frozen() and not is_frostbitten() and not is_blizzard():
		fire_arrow()
		$AttackCool.start()

func _on_attack_cool_timeout() -> void:
	if target in $AttackRange.get_overlapping_bodies():
		_on_attack_range_body_entered(target)
