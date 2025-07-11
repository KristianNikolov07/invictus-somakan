extends CharacterBody2D

const accel = 150
const max_falling_speed = 1000
const max_walking_speed = 200
const jump_force = 600
const gravity = 30
const jump_easing = -200
const dash_speed = 3 * max_walking_speed
var jumps_remaining = 1
var max_jumps = 1
var speed_mult = 1
var direction = 1
var damage_number_scale: float = 1.5
var damage_number_duration: float = 1.5

var selected_weapon

@onready var inventory = $UI/Inventory

func _ready() -> void:
	var node1 = PlayerStats.weapon1.weapon_action_scene.instantiate()
	$Weapons.add_child(node1)
	if PlayerStats.weapon2 != null:
		var node2 = PlayerStats.weapon2.weapon_action_scene.instantiate()
		$Weapons.add_child(node2)
		node2.process_mode = Node.PROCESS_MODE_DISABLED
		node2.hide()
	selected_weapon = PlayerStats.weapon1


func _physics_process(delta: float) -> void:
	if $DashTimer.is_stopped():
		process_movement()
	if is_on_floor():
		jumps_remaining = max_jumps
	move_and_slide()
	$ParryTimerTestLabel.text = str($Parry.time_left)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump") and jumps_remaining > 0:
		velocity.y = 0
		jumps_remaining -= 1
		velocity += Vector2(0, -jump_force)
	elif event.is_action_released("Jump"):
		velocity.y = max(velocity.y, jump_easing)
	elif event.is_action_pressed("Dash") and $DashCooldown.is_stopped():
		$DashTimer.start()
		$DashCooldown.start()
		velocity = Vector2(dash_speed * direction, 0)
	elif event.is_action_pressed("Attack"):
		attack()
	elif event.is_action_pressed("Interact"):
		interact_with()
	elif event.is_action_pressed("Parry"):
		$ParryArea.set_collision_mask_value(1, true)
		$ParryArea.set_collision_mask_value(3, true)
		$Parry.start()
	elif event.is_action_pressed("Weapon1"):
		switch_weapon(PlayerStats.weapon1)
	elif event.is_action_pressed("Weapon2"):
		switch_weapon(PlayerStats.weapon2)

	#elif event.is_action_released("PreviousWeapon") or event.is_action_released("NextWeapon"):
	#	if selected_weapon.item_name == PlayerStats.weapon1.item_name:
	#		selected_weapon = PlayerStats.weapon2
	#	else:
	#		selected_weapon = PlayerStats.weapon1
	elif event.is_action_pressed("UseConsumable1"):
		use_consumable(1)
	elif event.is_action_pressed("UseConsumable2"):
		use_consumable(2)

func check_parry(area):
	if !$Parry.is_stopped():
		if area.has_method("parry") and area.attacking:
			if(area.global_position.x < global_position.x and direction == -1 and area.velocity.x >= 0) or (area.global_position.x > global_position.x and direction == 1 and area.velocity.x <= 0):
				return $Parry.time_left
		elif area is Projectile:
			if(area.global_position.x < global_position.x and direction == -1) or (area.global_position.x > global_position.x and direction == 1):
				return $Parry.time_left
	return 0

func get_parry_time():
	return $Parry.wait_time

func stop_parry():
	if !$Parry.is_stopped():
		$Parry.stop()
		_on_parry_timeout()
		$Invincibility.start()

func process_movement():
	if $Parry.is_stopped():
		if Input.is_action_pressed("Right"):
			velocity.x = move_toward(velocity.x, max_walking_speed * speed_mult, accel)
			$ParryArea.rotation_degrees = 0
			direction = 1
		elif Input.is_action_pressed("Left"):
			velocity.x = move_toward(velocity.x, -max_walking_speed * speed_mult, accel)
			$ParryArea.rotation_degrees = 180
			direction = -1
		else:
			velocity.x = move_toward(velocity.x, 0, accel)
		
		if Input.is_action_pressed("Dash") and is_on_floor():
			speed_mult = 1.6
		elif not Input.is_action_pressed("Dash"):
			speed_mult = 1
	else:
		velocity.x = 0
	
	velocity.y = move_toward(velocity.y, max_falling_speed, gravity)

func attack():
	if selected_weapon != null:
		if $Weapons.get_child(0).visible:
			$Weapons.get_child(0).hit(direction)
		else:
			$Weapons.get_child(1).hit(direction)

func use_consumable(consumable: int):
	if $Consumables.get_node(str(consumable)) != null:
		$Consumables.get_node(str(consumable)).use(get_path())
		PlayerStats.remove_consumable(consumable - 1)

func open_crafting_menu():
	$UI/Crafting.show()
	$UI/Crafting.refresh()

func close_crafting_menu():
	$UI/Crafting.hide()

func damage_amount(amount: int, knockback) -> void:
	Utils.summon_damage_number(self, amount, Color.RED, damage_number_scale, damage_number_duration)
	set_collision_layer_value(1, false)
	$Invincibility.start()
	velocity.x = 1600 * knockback
	velocity.y = -500 * abs(knockback)
	PlayerStats.hp -= amount
	$Parry.stop()
	#if hp <= 0:
		#get_tree().quit()

	
func damage(hitbox: Hitbox, knockback):
	var is_crit = Utils.calculate_crit(hitbox.get_crit_chance())
	set_collision_layer_value(1, false)
	$Invincibility.start()
	$Parry.stop()
	velocity.x = 1600 * knockback
	velocity.y = -500 * abs(knockback)
	var damage = hitbox.get_damage() * (hitbox.get_crit_mult() if is_crit else 1)
	Utils.summon_damage_number(self, damage, Color.RED, damage_number_scale, damage_number_duration)
	PlayerStats.hp -= damage
	if PlayerStats.hp <= 0:
		queue_free()

func unlock_recipe(recipe: Recipe):
	PlayerStats.unlocked_recipes.append(recipe)

func _on_invincibility_timeout() -> void:
	set_collision_layer_value(1, true)

func _on_parry_timeout() -> void:
	$ParryArea.set_collision_mask_value(1, false)
	$ParryArea.set_collision_mask_value(3, false)

func begin_hitstop():
	$Hitstop.start()
	$Camera2D/Hitstop.play("flash")
	call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED)

func _on_hitstop_timeout() -> void:
	call_deferred("set_process_mode", Node.PROCESS_MODE_INHERIT)

func interact_with():
	for area in $InteractionRange.get_overlapping_areas():
		if area.has_method("interact"):
			area.interact(get_path())
			return

func _on_interaction_range_area_entered(area: Area2D) -> void:
	if area.has_method("pickup_weapon"):
		area.pickup_weapon()

func switch_weapon(weapon : WeaponItem):
	var wep1 = $Weapons.get_child(1)
	var wep2 = $Weapons.get_child(0)
	if PlayerStats.weapon2 != null:
		if weapon == PlayerStats.weapon1:
			wep1.process_mode = Node.PROCESS_MODE_DISABLED
			wep2.process_mode = Node.PROCESS_MODE_INHERIT
			selected_weapon = PlayerStats.weapon1
			wep1.hide()
			wep2.show()
		else:
			wep1.process_mode = Node.PROCESS_MODE_INHERIT
			wep2.process_mode = Node.NOTIFICATION_DISABLED
			selected_weapon = PlayerStats.weapon2
			wep1.show()
			wep2.hide()

func heal(_hp: int):
	PlayerStats.hp += _hp
	if PlayerStats.hp > PlayerStats.max_hp:
		PlayerStats.hp = PlayerStats.max_hp

func get_hp():
	return PlayerStats.hp

func get_max_hp():
	return PlayerStats.max_hp
