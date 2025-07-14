extends Area2D

func interact(player_path: String):
	var player = get_node(player_path)
	player.open_shop_menu()
