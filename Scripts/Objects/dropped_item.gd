extends Area2D

@export var item : Item

func pickup_weapon():
	if item.type == item.Type.WEAPON:
		PlayerStats.unlock_weapon(item)
		get_parent().queue_free()

func interact(player_path : String):
	var player = get_node(player_path)
	if player.inventory.add_item(item):
		get_parent().queue_free()

func set_item(_item : Item):
	item = _item
	$ItemIcon.texture = item.icon
