extends Consumable
var karen_circle_scene = preload("res://Scenes/Consumables/karen_head/karen_circle.tscn")

func use(player_path: String):
	var player = get_node(player_path)
	var karen_circle = karen_circle_scene.instantiate()
	karen_circle.global_position = player.global_position
	player.get_parent().add_child(karen_circle)
