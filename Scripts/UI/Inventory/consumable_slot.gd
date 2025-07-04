extends Control
@export var consumable: Item


func set_consumable(_item: Item) -> void:
	consumable = _item
	$ConsumableIcon.texture = consumable.icon
