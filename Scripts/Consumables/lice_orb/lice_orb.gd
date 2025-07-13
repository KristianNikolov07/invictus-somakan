extends Consumable
var lice = preload("res://Scripts/Consumables/lice_orb/lice.tscn")

func use(player_path: String):
	var player = get_node(player_path)
	var target = get_global_mouse_position()
	var new_lice: Projectile = lice.instantiate()
	new_lice.global_position = global_position
	new_lice.rotation = global_position.direction_to(target).angle()
	new_lice.shooter_vel = player.velocity
	new_lice.shooter_vel.y = 0
	get_tree().current_scene.add_child(new_lice, true)
