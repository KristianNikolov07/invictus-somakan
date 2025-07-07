extends Control
@export var consumable: Item


func set_consumable(_item: Item) -> void:
	if _item != null:
		consumable = _item.duplicate()
		$ConsumableIcon.texture = consumable.icon


func take_item():
	if consumable != null:
		consumable.amount -= 1
		if consumable.amount <= 0:
			clear()

func clear():
	$ConsumableIcon.texture = null
	consumable = null


func _on_pressed() -> void:
	if consumable != null:
		get_node("../../").show_item_options(self, true)
