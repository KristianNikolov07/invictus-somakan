extends Control

@export var weapon: Item


func set_weapon(_item: Item) -> void:
	weapon = _item
	$Name.text = weapon.item_name
	$WeaponIcon.texture = weapon.icon
