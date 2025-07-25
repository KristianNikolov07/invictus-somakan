extends Control
var item : ConsumableItem

func set_item(_item: Item) -> void:
	if _item != null:
		item = _item.duplicate()
		$Icon.texture = item.icon
		item.amount = _item.amount
		if item.amount == 1:
			$Amount.text = ""
		else:
			$Amount.text = str(item.amount)
	else:
		clear_item()


func clear_item() -> void:
	item = null
	$Icon.texture = null
	$Amount.text = ""
