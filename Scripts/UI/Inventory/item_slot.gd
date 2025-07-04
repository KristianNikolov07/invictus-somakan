extends Control

@export var item: Item


func set_item(_item: Item) -> void:
	item = _item
	$Name.text = item.item_name
	$ItemIcon.texture = item.icon

func increase_amount(amount:= 1):
	if item != null:
		item.amount += amount

func decrease_amount(amount:= 1):
	if item != null:
		item.amount -= amount
		if item.amount <= 0:
			item = null

func _on_texture_button_pressed() -> void:
	pass # Replace with function body.
