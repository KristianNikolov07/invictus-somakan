extends Consumable
var leech_shot_scene = preload("res://Scenes/Consumables/leech/leech_shot.tscn")

func use(player_path: String):
	var player = get_node(player_path)
	var leech_shot = leech_shot_scene.instantiate()
	leech_shot.global_position = player.global_position
	leech_shot.target = get_global_mouse_position()
	leech_shot.player = player
	player.get_parent().add_child(leech_shot)
