extends Enemy
class_name FlyingEnemy

var target : CharacterBody2D
var retarget_timer = Timer.new()

func _ready() -> void:
	super._ready()
	retarget_timer.wait_time = 1
	retarget_timer.timeout.connect(set_new_target)
	retarget_timer.autostart = true
	add_child(retarget_timer)
	set_new_target()

func _physics_process(delta: float) -> void:
	var move_velocity = Vector2.ZERO

	if target != null and hp > 0:
		var direction = (target.global_position - global_position).normalized()
		move_velocity = direction * speed

	if knockback_velocity.length() > 0:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)

	velocity = move_velocity + knockback_velocity
	if is_frozen() or is_frostbitten() or is_blizzard():
		velocity = Vector2.ZERO
	move_and_slide()


func set_new_target():
	var closest_player : CharacterBody2D = null
	for player in get_tree().get_nodes_in_group("Players"):
		if closest_player == null:
			closest_player = player
		elif closest_player.global_position.distance_to(global_position) > player.global_position.distance_to(global_position):
			closest_player = player
	target = closest_player


func damage(hitbox: Hitbox, knockback) -> void:
	var is_crit = Utils.calculate_crit(hitbox.get_crit_chance())
	set_collision_layer_value(1, false)
	invincibility_timer.start()
	if !can_be_knockedback:
		knockback = 0
	knockback_velocity.x = 600 * knockback
	knockback_velocity.y = -200 * abs(knockback)
	var dam = hitbox.get_damage() * (hitbox.get_crit_mult() if is_crit else 1)
	Utils.summon_damage_number(self, dam, Color.ORANGE_RED if is_crit else Color.WHITE, damage_number_scale, damage_number_duration)
	hp -= dam
	if hp <= 0:
		drop_loot()
		queue_free()
