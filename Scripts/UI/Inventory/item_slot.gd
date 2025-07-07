extends Control

@export var item: Item

func set_item(_item: Item) -> void:
	if _item != null:
		item = _item.duplicate()
		item.amount = _item.amount
		$Name.text = item.item_name
		$ItemIcon.texture = item.icon
		update_amount_label()

func clear_item() -> void:
	item = null
	$Name.text = ""
	$ItemIcon.texture = null

func increase_amount(amount:= 1):
	if item != null:
		item.amount += amount
		print(item.amount)
		update_amount_label()

func decrease_amount(amount:= 1):
	if item != null:
		item.amount -= amount
		update_amount_label()
		if item.amount <= 0:
			clear_item()

func _on_texture_button_pressed() -> void:
	if item != null:
		get_node("../../").show_item_options(self, false)
		
func update_amount_label():
	if item.amount <= 1:
		$Amount.text = ""
	else:
		$Amount.text = str(item.amount)
