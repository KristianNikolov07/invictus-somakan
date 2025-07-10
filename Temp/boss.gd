extends Enemy

var phase: int = 1
var stagger: float = 1
var is_dashing := false
var direction = 1
var target: CharacterBody2D = null
const smash_damage := 30
const smash_knockback := 1.75
const shockwave := preload("res://Temp/shockwave.tscn")
const rib := preload("res://Scenes/Projectiles/rib.tscn")
const finger := preload("res://Scenes/Projectiles/bone_finger.tscn")
@export var bone_positions: HBoxContainer


func _ready() -> void:
	super._ready()
	target_closest_player()


func _physics_process(delta: float) -> void:
	if not is_dashing and not attacking:
		direction = calculate_direction(target)
		if direction == -1:
			$Smash.scale = Vector2(-1, 1)
		else:
			$Smash.scale = Vector2(1, 1)
	
	if phase == 1 and hp <= max_hp/2:
		phase = 2
		speed = 100
		get_node("../BossPushers/AnimationPlayer").play("phase")
	
	if is_moving and not is_dashing:
		global_position.x = move_toward(global_position.x, target.global_position.x, delta*speed)
	elif is_moving:
		global_position.x += delta*speed*direction*12
	
	move_and_slide()


func _on_choose_attack_timeout() -> void:
	set_is_moving(false)
	var rand = randi_range(3, 3)
	match rand:
		1: attack_smash()
		2: attack_ram()
		3: attack_riberang()
		4: attack_bone_rain()
	target_closest_player()


func attack_smash() -> void:
	attacking = true
	$Attacks.play("smash")
	await $Attacks.animation_finished
	var shock1: Area2D = shockwave.instantiate()
	shock1.global_position = $Smash/Pivot/WeaponEnd.global_position
	var shock2 = shock1.duplicate()
	shock2.dir = -1
	get_tree().current_scene.add_child(shock1)
	get_tree().current_scene.add_child(shock2)
	await get_tree().create_timer(stagger).timeout
	set_is_moving(true)
	attacking = false
	$ChooseAttack.start(5)


func attack_ram() -> void:
	is_dashing = true
	await get_tree().create_timer(1).timeout
	set_is_moving(true)
	coll_damage = 20 * speed/60
	coll_knockback = 2.35
	await get_tree().create_timer(5).timeout
	is_dashing = false
	coll_damage = 5
	coll_knockback = 1
	$ChooseAttack.start(5)


func attack_riberang() -> void:
	attacking = true
	await get_tree().create_timer(0.5).timeout
	var new_rib: Projectile = rib.instantiate()
	new_rib.global_position = global_position
	new_rib.rotation = global_position.direction_to(target.global_position).angle()
	new_rib.shooter_vel = velocity
	get_tree().current_scene.add_child(new_rib)
	if phase == 2:
		new_rib = new_rib.duplicate()
		new_rib.rotation = global_position.direction_to(target.global_position + Vector2(0, 150)).angle()
		new_rib.shooter_vel = velocity
		get_tree().current_scene.add_child(new_rib)
		new_rib = new_rib.duplicate()
		new_rib.rotation = global_position.direction_to(target.global_position + Vector2(0, -150)).angle()
		new_rib.shooter_vel = velocity
		get_tree().current_scene.add_child(new_rib)
	await new_rib.tree_exited
	await get_tree().create_timer(0.5).timeout
	set_is_moving(true)
	attacking = false
	$ChooseAttack.start(4)


func attack_bone_rain() -> void:
	attacking = true
	set_is_moving(false)
	get_node("../Platforms/AnimationPlayer").play("bone_rain")
	await get_tree().create_timer(0.5).timeout
	for i in range(phase):
		var array := get_bone_positions()
		for j in range(phase+8):
			var new_finger: Area2D = finger.instantiate()
			new_finger.global_position = global_position
			new_finger.planned_pos = array.pop_at(randi_range(0, array.size()-1))
			get_tree().current_scene.add_child(new_finger)
		await get_tree().create_timer(1.5).timeout
	await get_tree().create_timer(2).timeout
	get_node("../Platforms/AnimationPlayer").play_backwards("bone_rain")
	set_is_moving(true)
	attacking = false
	$ChooseAttack.start(5)



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


func _on_boss_bounce_body_entered(body: Node2D) -> void:
	if is_dashing:
		direction *= -1
