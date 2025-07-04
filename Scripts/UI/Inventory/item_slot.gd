extends Control

@export var item: Item


func set_item(_item: Item) -> void:
	item = _item
	$Name.text = item.item_name
	$ItemIcon.texture = item.icon


func _on_texture_button_pressed() -> void:
	if item != null:
		get_node("../../").show_item_options(self)
