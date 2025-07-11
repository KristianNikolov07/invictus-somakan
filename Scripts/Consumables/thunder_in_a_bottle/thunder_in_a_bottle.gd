extends Consumable
var bottle = preload("res://Scenes/Consumables/thunder_in_a_bottle/bottle.tscn")

func use(player_path: String):
	var player = get_node(player_path)
	var target = get_global_mouse_position()
	target.y = player.global_position.y
	var bottle: Projectile = bottle.instantiate()
	bottle.global_position = global_position
	bottle.rotation = global_position.direction_to(target).angle()
	bottle.shooter_vel = player.velocity
	bottle.shooter_vel.y = 0
	get_tree().current_scene.add_child(bottle)
