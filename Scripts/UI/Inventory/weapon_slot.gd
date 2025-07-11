extends Control

@export var item: Item


func set_item(_item: Item) -> void:
	if _item != null:
		item = _item
		$WeaponIcon.texture = item.icon
	else:
		clear_item()

func clear_item():
	item = null
	$WeaponIcon.texture = null
