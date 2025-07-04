extends Control

@export var aspect: Item


func set_aspect(_item: Item) -> void:
	aspect = _item
	$Name.text = aspect.item_name
	$WeaponIcon.texture = aspect.icon
