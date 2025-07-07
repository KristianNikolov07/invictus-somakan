extends Control

@export var aspect: Item


func set_aspect(_item: Item) -> void:
	if _item != null:
		aspect = _item
		$AspectIcon.texture = aspect.icon

func clear():
	$AspectIcon.texture = null
	aspect = null


func _on_texture_button_pressed() -> void:
	if aspect != null:
		get_node("../../").show_item_options(self, true)
