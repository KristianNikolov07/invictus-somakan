extends Consumable
var lice = preload("res://Scripts/Consumables/lice_orb/lice.tscn")

func use(player_path: String):
	var player = get_node(player_path)
	var target = get_global_mouse_position()
	var lice: Projectile = lice.instantiate()
	lice.global_position = global_position
	lice.rotation = global_position.direction_to(target).angle()
	lice.shooter_vel = player.velocity
	lice.shooter_vel.y = 0
	get_tree().current_scene.add_child(lice)
