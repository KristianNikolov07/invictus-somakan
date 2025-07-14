extends CharacterBody2D

const accel = 150
const max_falling_speed = 1000
const max_walking_speed = 400
const jump_force = 1000
const gravity = 40
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
	instantiate_weapons()
	instantiate_consumables()

func _physics_process(_delta: float) -> void:
	if $DashTimer.is_stopped():
		process_movement()
	if is_on_floor():
		jumps_remaining = max_jumps
	if PlayerStats.hp > 0:
		animations()
		move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump") and is_on_floor():
		velocity.y = 0
		velocity += Vector2(0, -jump_force)
	elif event.is_action_pressed("Jump") and PlayerStats.has_double_jump and jumps_remaining > 0:
		jumps_remaining -= 1
		velocity.y = 0
		velocity += Vector2(0, -jump_force)
	elif event.is_action_released("Jump"):
		velocity.y = max(velocity.y, jump_easing)
	elif event.is_action_pressed("Dash") and $DashCooldown.is_stopped() and $PlayerSprite.animation != "parry_ready" and $PlayerSprite.animation != "parry":
		$DashTimer.start()
		$DashCooldown.start()
		velocity = Vector2(dash_speed * direction, 0)
	elif event.is_action_pressed("Attack") and $PlayerSprite.animation != "parry_ready":
		attack()
	elif event.is_action_pressed("Interact"):
		interact_with()
	elif event.is_action_pressed("Parry") and $PlayerSprite.animation != "parry_ready" and $PlayerSprite.animation != "parry" and $PlayerSprite.animation != "dash":
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
	elif event.is_action_pressed("UseConsumable1") and $PlayerSprite.animation != "dash":
		use_consumable(1)
	elif event.is_action_pressed("UseConsumable2") and $PlayerSprite.animation != "dash":
		use_consumable(2)

func instantiate_consumables():
	if PlayerStats.consumables[0] != null:
		var node = PlayerStats.consumables[0].consumable_action.instantiate()
		node.name = "1"
		get_node("Consumables").add_child(node)
	if PlayerStats.consumables[1] != null:
		var node = PlayerStats.consumables[1].consumable_action.instantiate()
		node.name = "2"
		get_node("Consumables").add_child(node)

func instantiate_weapons():
	instantiate_weapon_1(PlayerStats.weapon1)
	instantiate_weapon_2(PlayerStats.weapon2)
	switch_weapon(PlayerStats.weapon1)

func instantiate_weapon_1(weapon: WeaponItem):
	if weapon != null:
		$UI/SelectedWeaponUI.set_weapon_1(PlayerStats.weapon1)
		var node1 = PlayerStats.weapon1.get_action_node()
		node1.name = "1"
		$Weapons.add_child(node1)
	else:
		if $Weapons.get_node("1") != null:
			$Weapons.get_node("1").queue_free()
	
func instantiate_weapon_2(weapon: WeaponItem):
	if PlayerStats.weapon2 != null:
		$UI/SelectedWeaponUI.set_weapon_2(PlayerStats.weapon2)
		var node2 = PlayerStats.weapon2.get_action_node()
		node2.name = "2"
		$Weapons.add_child(node2)
		node2.process_mode = Node.PROCESS_MODE_DISABLED
		node2.hide()
	else:
		if $Weapons.get_node("2") != null:
			$Weapons.get_node("2").queue_free()

func remove_weapons():
	instantiate_weapon_1(null)
	instantiate_weapon_2(null)
	selected_weapon = null

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
			$PlayerSprite.flip_h = false
			direction = 1
		elif Input.is_action_pressed("Left"):
			velocity.x = move_toward(velocity.x, -max_walking_speed * speed_mult, accel)
			$ParryArea.rotation_degrees = 180
			$PlayerSprite.flip_h = true
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


func animations() -> void:
	if not $Parry.is_stopped():
		$PlayerSprite.play("parry_ready")
		return
	if $PlayerSprite.animation == "parry" or $PlayerSprite.animation == "cast":
		return
	if not $DashTimer.is_stopped():
		$PlayerSprite.play("dash")
		return
	if $PlayerSprite.animation == "consume":
		return
	
	if is_on_floor() and velocity.x == 0:
		$PlayerSprite.play("idle")
	elif is_on_floor() and Input.is_action_pressed("Dash"):
		$PlayerSprite.play("sprint")
	elif is_on_floor():
		$PlayerSprite.play("walk")
	elif velocity.y < 0:
		$PlayerSprite.play("jump")
	elif velocity.y > 0:
		$PlayerSprite.play("fall")


func attack():
	if selected_weapon != null:
		$PlayerSprite.play("cast")
		if $Weapons.get_child(0).visible:
			$Weapons.get_child(0).hit(direction)
		else:
			$Weapons.get_child(1).hit(direction)

func use_consumable(consumable: int):
	if $Consumables.get_node(str(consumable)) != null:
		$PlayerSprite.play("consume")
		$Consumables.get_node(str(consumable)).use(get_path())
		PlayerStats.remove_consumable(consumable - 1)

func open_crafting_menu():
	$UI/Crafting.show()
	$UI/Crafting.refresh()

func close_crafting_menu():
	$UI/Crafting.hide()
	
func open_upgrades_menu():
	$UI/Upgrades.show()
	$UI/Upgrades.refresh()

func close_upgrades_menu():
	$UI/Upgrades.hide()
	
func open_shop_menu():
	$UI/Shop.show()

func damage_amount(amount: int, knockback) -> void:
	Utils.summon_damage_number(self, amount, Color.RED, damage_number_scale, damage_number_duration)
	set_collision_layer_value(1, false)
	$Invincibility.start()
	velocity.x = 1600 * knockback
	velocity.y = -500 * abs(knockback)
	PlayerStats.hp -= amount
	$Parry.stop()
	if PlayerStats.hp <= 0:
		$PlayerSprite.play("death")
		await $PlayerSprite.animation_finished
		get_tree().change_scene_to_file("res://Scenes/UI/game_over.tscn")

	
func damage(hitbox: Hitbox, knockback):
	var is_crit = Utils.calculate_crit(hitbox.get_crit_chance())
	set_collision_layer_value(1, false)
	$Invincibility.start()
	$Parry.stop()
	velocity.x = 1600 * knockback
	velocity.y = -500 * abs(knockback)
	var damage_num = hitbox.get_damage() * (hitbox.get_crit_mult() if is_crit else 1)
	Utils.summon_damage_number(self, damage_num, Color.RED, damage_number_scale, damage_number_duration)
	PlayerStats.hp -= damage_num
	if PlayerStats.hp <= 0:
		$PlayerSprite.play("death")
		await $PlayerSprite.animation_finished
		get_tree().change_scene_to_file("res://Scenes/UI/game_over.tscn")

func unlock_recipe(recipe: Recipe):
	PlayerStats.unlocked_recipes.append(recipe)

func _on_invincibility_timeout() -> void:
	set_collision_layer_value(1, true)

func _on_parry_timeout() -> void:
	$ParryArea.set_collision_mask_value(1, false)
	$ParryArea.set_collision_mask_value(3, false)

func begin_hitstop():
	$ParrySound.play()
	$Hitstop.start()
	$Camera2D/Hitstop.play("flash")
	$Parry.stop()
	$PlayerSprite.play("parry")
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
	if weapon == null:
		selected_weapon = null
	if weapon != selected_weapon:
		for w in $Weapons.get_children():
			w.process_mode = Node.PROCESS_MODE_DISABLED
			w.hide()
		if weapon == PlayerStats.weapon1:
			$Weapons.get_node("1").process_mode = Node.PROCESS_MODE_INHERIT
			selected_weapon = PlayerStats.weapon1
			$UI/SelectedWeaponUI.select_weapon_1()
			$Weapons.get_node("1").show()
		elif weapon == PlayerStats.weapon2:
			$Weapons.get_node("2").process_mode = Node.PROCESS_MODE_INHERIT
			selected_weapon = PlayerStats.weapon2
			$UI/SelectedWeaponUI.select_weapon_2()
			$Weapons.get_node("2").show()

func heal(_hp: int):
	PlayerStats.hp += _hp
	if PlayerStats.hp > PlayerStats.max_hp:
		PlayerStats.hp = PlayerStats.max_hp

func get_hp():
	return PlayerStats.hp

func get_max_hp():
	return PlayerStats.max_hp


func _on_player_sprite_animation_finished() -> void:
	if $PlayerSprite.animation == "parry" or $PlayerSprite.animation == "cast" or $PlayerSprite.animation == "consume":
		$PlayerSprite.play("idle")
