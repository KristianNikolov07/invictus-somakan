extends Control
@export var consumable: Item


func set_consumable(_item: Item) -> void:
	consumable = _item
	$Name.text = consumable.item_name
	$WeaponIcon.texture = consumable.icon
