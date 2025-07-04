extends Control

@export var weapon: Item


func set_weapon(_item: Item) -> void:
	weapon = _item
	$WeaponIcon.texture = weapon.icon
