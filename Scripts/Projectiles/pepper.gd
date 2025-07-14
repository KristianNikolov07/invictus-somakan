extends Projectile

var cooking_phase = 1
var explosion_damage = 8
var already_hit := false

func _ready() -> void:
	var rand = randf_range(0, 359)
	$Sprite2D.rotation_degrees = rand
	$CollisionShape2D.rotation_degrees = rand + 90
	
	match cooking_phase:
		2:
			speed = 400
			damage = 40
			knockback = 0.8
			explosion_damage = 20
			$Sprite2D.texture = load("res://Textures/Projectiles/yellow_pepper.png")
		3:
			speed = 800
			damage = 80
			knockback = 1.2
			explosion_damage = 40
			$Sprite2D.texture = load("res://Textures/Projectiles/red_pepper.png")
		4:
			speed = 120
			damage = 150
			knockback = 1.8
			explosion_damage = 60
			$Sprite2D.texture = load("res://Textures/Projectiles/black_pepper.png")
			$CollisionShape2D.scale = Vector2(3.2, 3.2)
			$Sprite2D.scale = Vector2(3.2, 3.2)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	$Sprite2D.rotation_degrees += 3
	$CollisionShape2D.rotation_degrees += 3


func _on_body_entered(body: Node2D) -> void:
	if not already_hit:
		if body.is_in_group("Enemies"):
			already_hit = true
			if applied_aspect != null and applied_aspect.aspect_name != "Explosion":
				applied_aspect.apply_effect(body)
			body.damage_amount(damage, knockback * calculate_direction(body))
			if cooking_phase > 2 or (applied_aspect != null and applied_aspect.aspect_name == "Explosion"):
				var ex = Utils.summon_explosion(global_position, 3 if cooking_phase == 4 else 1.5, explosion_damage, knockback, 1.2, true if cooking_phase == 4 else false, true)
				get_tree().current_scene.call_deferred("add_child", ex)
			queue_free()
		elif not body.is_in_group("Players") and cooking_phase > 2:
			var ex = Utils.summon_explosion(global_position, 3 if cooking_phase == 4 else 1.5, explosion_damage, knockback, 1.2, true if cooking_phase == 4 else false, true)
			get_tree().current_scene.call_deferred("add_child", ex)
			queue_free()
		elif not body.is_in_group("Players"):
			queue_free()


func _on_area_entered(area: Area2D) -> void:
	if cooking_phase == 4 and area.has_method("calculate_direction"):
		var ex = Utils.summon_explosion(global_position, 3, explosion_damage, knockback, 1, true, true)
		get_tree().current_scene.call_deferred("add_child", ex)
		queue_free()


func _on_death_timer_timeout() -> void:
	queue_free()
