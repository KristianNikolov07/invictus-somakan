extends Consumable
var vortex_scene = preload("res://Scenes/Consumables/healing_vortex/vortex.tscn")

func use(player_path: String):
	var vortex = vortex_scene.instantiate()
	vortex.global_position = get_node("../../").global_position
	get_node("../../../").add_child(vortex, true)
