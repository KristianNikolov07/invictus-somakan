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


func _ready() -> void:
	target_closest_player()


func _physics_process(delta: float) -> void:
	if not is_dashing:
		direction = calculate_direction(target)
		if direction == -1:
			$Smash.scale = Vector2(-1, 1)
		else:
			$Smash.scale = Vector2(1, 1)
	
	if phase == 1 and hp <= max_hp/2:
		phase = 2
	
	if is_moving and not is_dashing:
		global_position.x = move_toward(global_position.x, target.global_position.x, delta*speed)
	elif is_moving:
		global_position.x += delta*speed*direction*12


func _on_choose_attack_timeout() -> void:
	set_is_moving(false)
	attack_riberang()


func attack_smash() -> void:
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
	$ChooseAttack.start(6)

func attack_ram() -> void:
	is_dashing = true
	await get_tree().create_timer(1).timeout
	set_is_moving(true)
	coll_damage = 20
	coll_knockback = 2.35
	await get_tree().create_timer(5).timeout
	is_dashing = false
	coll_damage = 5
	coll_knockback = 1
	$ChooseAttack.start(6)


func attack_riberang() -> void:
	await get_tree().create_timer(0.5).timeout
	var new_rib: Projectile = rib.instantiate()
	new_rib.global_position = global_position
	new_rib.rotation = global_position.direction_to(target.global_position).angle()
	new_rib.shooter_vel = velocity
	get_tree().current_scene.add_child(new_rib)
	await new_rib.tree_exited
	await get_tree().create_timer(0.5).timeout
	set_is_moving(true)
	$ChooseAttack.start(5)


func attack_bone_rain() -> void:
	pass


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
