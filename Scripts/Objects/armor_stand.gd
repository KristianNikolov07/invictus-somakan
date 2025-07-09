extends Area2D
@export var weapon: Item

func interact(player_path : String):
	var player = get_node(player_path)
	if PlayerStats.weapon1 == null:
		PlayerStats.set_weapon1(weapon)
		player.selected_weapon = weapon
	elif PlayerStats.weapon2 == null:
		PlayerStats.set_weapon2(weapon)
		player.selected_weapon = weapon
