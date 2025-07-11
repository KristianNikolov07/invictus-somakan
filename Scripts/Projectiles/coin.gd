extends Area2D

var velocity: Vector2
var shooter_vel: Vector2
var dir := 1


func _ready() -> void:
	velocity = Vector2(200, -450)
	velocity.x *= dir
	shooter_vel.x = clampf(shooter_vel.x, -500, 500)
	shooter_vel.y = clampf(shooter_vel.y, -100, 100)


func _physics_process(delta: float) -> void:
	global_position += (velocity+shooter_vel) * delta
	velocity.x = move_toward(velocity.x, 0, delta*5)
	velocity.y -= -200 * delta*3


func has_line_of_sight(enemy: Node2D):
	var space_state = get_world_2d().direct_space_state
	var from = global_position
	var to = enemy.global_position
	var res: Dictionary = space_state.intersect_ray(PhysicsRayQueryParameters2D.create(from, to, 4294967295, [self, enemy]))
	
	return res.is_empty()

func find_target() -> Node2D:
	var best_target = null
	var best_dist = INF
	
	for coin: Node2D in get_tree().get_nodes_in_group("Coins"):
		if coin == self: continue
		var dist = global_position.distance_squared_to(coin.global_position)
		if dist < best_dist and has_line_of_sight(coin):
			best_dist = dist
			best_target = coin
	
	if best_target != null:
		return best_target
	
	for enemy: Node2D in get_tree().get_nodes_in_group("Enemies"):
		var dist = global_position.distance_squared_to(enemy.global_position)
		if dist < best_dist and has_line_of_sight(enemy):
			best_dist = dist
			best_target = enemy
	
	return best_target

func _on_area_entered(area: Area2D) -> void:
	var target = find_target()
	if target != null:
		area.rotation = global_position.direction_to(target.global_position).angle()
	else:
		area.rotation_degrees += randf_range(-120, 120)
	
	#area.speed += 200
	area.damage += 20
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
