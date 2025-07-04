extends Control

@export var item: Item

func set_item(_item: Item) -> void:
	item = _item
	$Name.text = item.item_name
	$ItemIcon.texture = item.icon

func clear_item() -> void:
	item = null
	$Name.text = ""
	$ItemIcon.texture = null

func increase_amount(amount:= 1):
	if item != null:
		item.amount += amount

func decrease_amount(amount:= 1):
	if item != null:
		item.amount -= amount
		if item.amount <= 0:
			clear_item()

func _on_texture_button_pressed() -> void:
	if item != null:
		get_node("../../").show_item_options(self, false)
