extends WalkingEnemy

var direction = 1
var arrow := preload("res://Scenes/Projectiles/arrow.tscn")


func fire_arrow() -> void:
	var arrow: Projectile = arrow.instantiate()
	arrow.global_position = global_position
	arrow.rotation = global_position.direction_to(target.global_position).angle()
	arrow.shooter_vel = velocity
	arrow.can_hit_enemies = false
	get_tree().current_scene.add_child(arrow)

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
		set_is_moving(false)
		if $AttackCharge.is_stopped() and $AttackCool.is_stopped():
			$AttackCharge.start()

func _on_attack_range_body_exited(body: Node2D) -> void:
	if target != null and body == target:
		if not $AttackCharge.is_stopped():
			await $AttackCharge.timeout
		
		set_is_moving(true)


func _on_attack_charge_timeout() -> void:
	fire_arrow()
	$AttackCool.start()

func _on_attack_cool_timeout() -> void:
	if target in $AttackRange.get_overlapping_bodies():
		_on_attack_range_body_entered(target)
