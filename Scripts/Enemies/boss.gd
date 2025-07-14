extends Enemy

var phase: int = 1
var stagger: float = 1
var is_dashing := false
var direction = 1
var target: CharacterBody2D = null
const smash_damage := 30
const smash_knockback := 1.75
const shockwave := preload("res://Scenes/Projectiles/shockwave.tscn")
const rib := preload("res://Scenes/Projectiles/rib.tscn")
const finger := preload("res://Scenes/Projectiles/bone_finger.tscn")
@export var bone_positions: HBoxContainer
signal dead


func _ready() -> void:
	super._ready()
	target_closest_player()
	set_is_moving(false)


func _physics_process(delta: float) -> void:
	if not is_dashing and not attacking:
		direction = calculate_direction(target)
		if direction == -1:
			$BossSprite.flip_h = false
			$BossSprite.position.x = -43
			$Smash.scale = Vector2(-1, 1)
		else:
			$BossSprite.flip_h = true
			$BossSprite.position.x = 43
			$Smash.scale = Vector2(1, 1)
	
	if is_moving and not is_dashing:
		global_position.x = move_toward(global_position.x, target.global_position.x, delta*speed)
	elif is_moving:
		global_position.x += delta*speed*direction*12
	
	move_and_slide()


func start():
	set_is_moving(true)
	$ChooseAttack.start()
	$BossSprite.play("walk")


func _on_choose_attack_timeout() -> void:
	set_is_moving(false)
	var rand = randi_range(1, 1)
	match rand:
		1: attack_smash()
		2: attack_ram()
		3: attack_riberang()
		4: attack_bone_rain()
	target_closest_player()


func attack_smash() -> void:
	attacking = true
	$BossSprite.play("smash_ready")
	await $BossSprite.animation_finished
	$Attacks.play("smash")
	if phase == 2: $BossSprite.play("smash_fast")
	else: $BossSprite.play("smash")
	await $Attacks.animation_finished
	get_node("../ArenaCam/ScreenShaker2D").shake_screen(1, 20, true, 50)
	var shock1: Area2D = shockwave.instantiate()
	shock1.global_position = $Smash/Pivot/WeaponEnd.global_position
	var shock2 = shock1.duplicate()
	shock2.dir = -1
	get_tree().current_scene.add_child(shock1)
	get_tree().current_scene.add_child(shock2)
	if phase == 2:
		for i in range(2):
			await $BossSprite.animation_finished
			$Smash.scale.x *= -1
			$BossSprite.position.x *= -1
			$BossSprite.flip_h = !$BossSprite.flip_h
			$Attacks.play("smash")
			if i == 0: $BossSprite.play("smash_fast")
			else: $BossSprite.play("smash")
			await $Attacks.animation_finished
			get_node("../ArenaCam/ScreenShaker2D").shake_screen(1, 20, true, 50)
			shock1 = shockwave.instantiate()
			shock1.global_position = $Smash/Pivot/WeaponEnd.global_position
			shock2 = shock1.duplicate()
			shock2.dir = -1
			get_tree().current_scene.add_child(shock1)
			get_tree().current_scene.add_child(shock2)
	$ChooseAttack.start(5)
	await $BossSprite.animation_finished
	attacking = false
	set_is_moving(true)
	$BossSprite.play("walk")


func attack_ram() -> void:
	is_dashing = true
	if phase == 2: $BossSprite.play("ram_ready_fast")
	else: $BossSprite.play("ram_ready")
	await $BossSprite.animation_finished
	if phase == 2: $BossSprite.play("ram_fast")
	else: $BossSprite.play("ram")
	set_is_moving(true)
	coll_damage = 20 * speed/60
	coll_knockback = 2.35
	await get_tree().create_timer(5).timeout
	is_dashing = false
	coll_damage = 5
	coll_knockback = 1
	$ChooseAttack.start(5)
	$BossSprite.play("walk")


func attack_riberang() -> void:
	$BossSprite.play("riberang_throw")
	await $BossSprite.animation_finished
	var new_rib: Projectile = rib.instantiate()
	new_rib.global_position = global_position
	new_rib.rotation = global_position.direction_to(target.global_position).angle()
	new_rib.shooter_vel = velocity
	get_tree().current_scene.add_child(new_rib)
	if phase == 1: attacking = true
	if phase == 2:
		for i in range(2):
			$BossSprite.play("riberang_throw_fast")
			await get_tree().create_timer(0.5).timeout
			new_rib = rib.instantiate()
			new_rib.global_position = global_position
			new_rib.rotation = global_position.direction_to(target.global_position).angle()
			new_rib.shooter_vel = velocity
			await $BossSprite.animation_finished
			get_tree().current_scene.add_child(new_rib)
	attacking = true
	await new_rib.tree_exited
	$BossSprite.play("riberang_catch")
	await $BossSprite.animation_finished
	set_is_moving(true)
	attacking = false
	$ChooseAttack.start(4)
	$BossSprite.play("walk")


func attack_bone_rain() -> void:
	attacking = true
	for i in range(phase):
		$BossSprite.play("bone_rain_ready")
		var array := get_bone_positions()
		await $BossSprite.animation_finished
		for j in range(phase+7):
			var new_finger: Area2D = finger.instantiate()
			new_finger.global_position = global_position
			new_finger.planned_pos = array.pop_at(randi_range(0, array.size()-1))
			get_tree().current_scene.add_child(new_finger)
		$BossSprite.play("bone_rain")
		await $BossSprite.animation_finished
	await get_tree().create_timer(2).timeout
	set_is_moving(true)
	attacking = false
	$ChooseAttack.start(6-phase)
	$BossSprite.play("walk")


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
		phase = 2
		speed = 100
		get_node("../BossPushers/AnimationPlayer").play("phase")
	elif hp <= 0:
		$CollisionShape2D.queue_free()
		$RibReturn.queue_free()
		$CollisionDamage.queue_free()
		attacking = true
		set_is_moving(false)
		$Attacks.stop(true)
		$ChooseAttack.stop()
		$BossSprite.play("default")
		await get_tree().create_timer(1.5).timeout
		$BossSprite.play("death")
		$Break.play()
		await $Break.finished
		var ex = Utils.summon_explosion(global_position, 12, 0, 0, 0.9)
		ex.get_node("Boom").volume_db = 6
		get_tree().current_scene.add_child(ex)
		await get_tree().create_timer(1).timeout
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
		phase = 2
		speed = 100
		get_node("../BossPushers/AnimationPlayer").play("phase")
	elif hp <= 0:
		$CollisionShape2D.queue_free()
		$RibReturn.queue_free()
		$CollisionDamage.queue_free()
		attacking = true
		set_is_moving(false)
		$Attacks.stop(true)
		$ChooseAttack.stop()
		$BossSprite.play("default")
		await get_tree().create_timer(1.5).timeout
		$BossSprite.play("death")
		$Break.play()
		await $Break.finished
		var ex = Utils.summon_explosion(global_position, 12, 0, 0, 0.9)
		get_node("../ArenaCam/ScreenShaker2D").shake_screen(2.5, 100, true, 60)
		ex.get_node("Boom").volume_db = 6
		get_tree().current_scene.add_child(ex)
		$BossSprite.hide()
		await get_tree().create_timer(2.5).timeout
		drop_loot()
		dead.emit()
		queue_free()


func _on_collision_damage_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		var knockback_dir = calculate_direction(body)
		if not attacking:
			body.damage_amount(coll_damage, coll_knockback * knockback_dir)

func _on_smash_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		var knockback_dir = calculate_direction(body)
		body.damage_amount(smash_damage, smash_knockback * knockback_dir)


func target_closest_player() -> void:
	var plater_array = get_tree().get_nodes_in_group("Players")
	var candidate = null
	var smallest_distance = INF
	
	for player: CharacterBody2D in plater_array:
		var distance = player.global_position.distance_to(global_position)
		if distance < smallest_distance:
			smallest_distance = distance
			candidate = player
	
	target = candidate

func get_bone_positions() -> Array[Vector2]:
	var targets = bone_positions.get_children()
	var array: Array[Vector2]
	for child: Control in targets:
		array.append(child.global_position)
	
	return array

func calculate_direction(body):
	var knockback_dir = 1
	if body.global_position.x > global_position.x:
		knockback_dir = 1
	else:
		knockback_dir = -1
	return knockback_dir


func _on_boss_bounce_body_entered(_body: Node2D) -> void:
	if is_dashing:
		direction *= -1
		$BossSprite.flip_h = !$BossSprite.flip_h
		$BossSprite.position.x *= -1
