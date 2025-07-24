extends Control

@export var item: Item

func set_item(_item: Item) -> void:
	if _item != null:
		item = _item.duplicate()
		item.amount = _item.amount
		$Name.text = item.item_name
		$ItemIcon.texture = item.icon
		update_amount_label()
	else:
		clear_item()

func clear_item() -> void:
	item = null
	$Name.text = ""
	$Amount.text = ""
	$ItemIcon.texture = null

func _on_texture_button_pressed() -> void:
	if item != null:
		get_node("../../").show_item_options(self, false)
		
func update_amount_label():
	if item.amount <= 1:
		$Amount.text = ""
	else:
		$Amount.text = str(item.amount)
