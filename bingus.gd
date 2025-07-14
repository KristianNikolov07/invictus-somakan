extends Enemy

var max_speed = 100
var travel_spot: Vector2
var prev := Vector2.ZERO
var is_started := false
var laser_aim := Vector2.ZERO
var phase = 1
@export var bound: Node2D
const grenade := preload("res://grenade.tscn")
signal dead


func start() -> void:
	travel_spot = pick_travel_spot()
	$Laser.start()
	$Grenade.start()
	is_started = true


func _physics_process(delta: float) -> void:
	if is_started:
		prev = global_position
		global_position.x = move_toward(global_position.x, travel_spot.x, delta*speed)
		global_position.y = move_toward(global_position.y, travel_spot.y, delta*speed)
		if prev.x - global_position.x == 0:
			travel_spot.x = pick_travel_spot().x
		if prev.y - global_position.y == 0:
			travel_spot.y = pick_travel_spot().y
		
		$Lasers/Loc1.look_at(laser_aim)
		$Lasers/Loc2.look_at(laser_aim)
		$Lasers/Loc1.rotation_degrees -= 90
		$Lasers/Loc2.rotation_degrees -= 90
		print(laser_aim)


func laser_attack():
	laser_aim = get_tree().get_nodes_in_group("Players")[0].global_position
	$AnimationPlayer.play("laser_prep")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("laser_shoot")


func damage(hitbox: Hitbox, knockback):
	var is_crit = Utils.calculate_crit(hitbox.get_crit_chance())
	set_collision_layer_value(1, false)
	invincibility_timer.start()
	if !can_be_knockedback:
		knockback = 0
	velocity.x = 1600 * knockback
	velocity.y = -500 * abs(knockback)
	var dam = hitbox.get_damage() * (hitbox.get_crit_mult() if is_crit else 1)
	Utils.summon_damage_number(self, dam, Color.ORANGE_RED if is_crit else Color.WHITE, damage_number_scale, damage_number_duration)
	hp -= dam
	if hp <= max_hp/2 and phase < 2:
		pass
	elif hp <= 0:
		drop_loot()
		dead.emit()
		queue_free()

func damage_amount(amount: int, knockback) -> void:
	Utils.summon_damage_number(self, amount, Color.WHITE, damage_number_scale, damage_number_duration)
	set_collision_layer_value(1, false)
	invincibility_timer.start()
	if !can_be_knockedback:
		knockback = 0
	velocity.x = 1600 * knockback
	velocity.y = -500 * abs(knockback)
	hp -= amount
	if hp <= max_hp/2 and phase < 2:
		pass
	elif hp <= 0:
		drop_loot()
		dead.emit()
		queue_free()


func pick_travel_spot() -> Vector2:
	var spot := Vector2.ZERO
	spot.x = randf_range(bound.get_node("Left").global_position.x, bound.get_node("Right").global_position.x)
	spot.y = randf_range(bound.get_node("Up").global_position.y, bound.get_node("Down").global_position.y)
	
	return spot


func _on_laser_timeout() -> void:
	laser_attack()


func _on_grenade_timeout() -> void:
	var node: Area2D = grenade.instantiate()
	node.global_position = global_position
	get_tree().current_scene.add_child(node)
	$Grenade.start(randf_range(1.1, 2))
