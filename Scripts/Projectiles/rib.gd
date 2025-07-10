extends Projectile

@export var return_speed: float = 10
@export var rot_speed: float = 4


func _physics_process(delta: float) -> void:
	$Sprite2D.rotation_degrees += rot_speed
	$CollisionShape2D.rotation_degrees += rot_speed
	var direction  = Vector2.RIGHT.rotated(rotation)
	global_position += (speed * direction + shooter_vel) * delta
	if $Return.is_stopped(): speed -= return_speed


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") and can_hit_players:
		var knockback_dir = calculate_direction(body)
		var parry_time_left = body.check_parry(self)
		if parry_time_left > 0 and can_be_parried:
			$Hitstop.start()
			body.begin_hitstop()
			call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED)
			print(parry_time_left)
			var is_perfect = parry_time_left > body.get_parry_time() / 1.2
			body.stop_parry()
			if not is_perfect and times_parried <= 1:
				body.damage_amount(damage / 3, knockback / 3)
				speed = -600
			else:
				damage *= 2
				speed = -1200
				rot_speed *= 2
			
			$Return.stop()
			can_hit_players = false
			times_parried += 1
			rot_speed *= 3
		else:
			body.damage_amount(damage, knockback * knockback_dir)
		
	elif body.is_in_group("Enemies") and can_hit_enemies and $Return.is_stopped():
		if times_parried > 0:
			body.damage_amount(damage, knockback)
		queue_free()


func _on_hitstop_timeout() -> void:
	call_deferred("set_process_mode", Node.PROCESS_MODE_INHERIT)
