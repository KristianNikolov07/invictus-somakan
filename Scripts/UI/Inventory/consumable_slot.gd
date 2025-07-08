extends Control
@export var consumable: Item


func set_consumable(_item: Item) -> void:
	if _item != null:
		consumable = _item.duplicate()
		consumable.amount = 1
		$ConsumableIcon.texture = consumable.icon


func take_item():
	if consumable != null:
		consumable.amount -= 1
		if consumable.amount <= 0:
			clear_item()


func increase_amount(amount:= 1):
	if consumable != null:
		consumable.amount += amount
		#update_amount_label()

func decrease_amount(amount:= 1):
	if consumable != null:
		consumable.amount -= amount
		#update_amount_label()
		if consumable.amount <= 0:
			clear_item()

func clear_item() -> void:
	consumable = null
	$ConsumableIcon.texture = null


func _on_pressed() -> void:
	if consumable != null:
		get_node("../../").show_item_options(self, true)
