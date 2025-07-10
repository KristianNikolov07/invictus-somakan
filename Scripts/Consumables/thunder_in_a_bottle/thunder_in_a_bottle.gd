extends Consumable
var bottle = preload("res://Scenes/Consumables/thunder_in_a_bottle/bottle.tscn")

func use(player_path: String):
	var player = get_node(player_path)
	var direction = player
	var bottle: Projectile = bottle.instantiate()
	bottle.global_position = global_position
	bottle.rotation = global_position.direction_to(target.global_position).angle()
	bottle.shooter_vel = velocity
	get_tree().current_scene.add_child(bottle)
