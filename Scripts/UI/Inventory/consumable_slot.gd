extends Control
@export var item: Item


func set_item(_item: Item) -> void:
	if _item != null:
		item = _item.duplicate()
		$ConsumableIcon.texture = item.icon
		item.amount = _item.amount
		if item.amount == 1:
			$Amount.text = ""
		else:
			$Amount.text = str(item.amount)
	else:
		clear_item()


func clear_item() -> void:
	item = null
	$ConsumableIcon.texture = null


func _on_pressed() -> void:
	if item != null:
		get_node("../../").show_item_options(self, true)
