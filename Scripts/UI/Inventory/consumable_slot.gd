extends Control
@export var consumable: Item


func set_consumable(_item: Item) -> void:
	if _item != null:
		consumable = _item
		$ConsumableIcon.texture = consumable.icon
