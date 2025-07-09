extends Item
class_name WeaponItem

@export var weapon_action_scene : PackedScene

func get_action_node():
	var node = weapon_action_scene.instantiate()
	node.weapon = self
	return node
