extends Control
@export var consumable: Item


func set_consumable(_item: Item) -> void:
	consumable = _item
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
