extends Control

@export var item: Item


func set_item(_item: Item) -> void:
	if _item != null:
		item = _item.duplicate()
		$AspectIcon.texture = item.icon
	else:
		clear_item()

func clear_item():
	$AspectIcon.texture = null
	item = null


func _on_texture_button_pressed() -> void:
	if item != null:
		get_node("../../").show_item_options(self, true)
