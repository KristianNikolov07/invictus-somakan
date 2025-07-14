extends Area2D

func interact(player_path : String):
	var player = get_node(player_path)
	PlayerStats.set_weapon1(null)
	PlayerStats.set_weapon2(null)
	player.remove_weapons()
	player.switch_weapon(null)
