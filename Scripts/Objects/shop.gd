extends Area2D


func interact(player_path: String):
	var player = get_node(player_path)
	player.get_node("UI/Inventory").hide()
	player.get_node("UI/Shop").show()
