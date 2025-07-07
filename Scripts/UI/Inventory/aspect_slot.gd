extends Control

@export var aspect: Item


func set_aspect(_item: Item) -> void:
	if _item != null:
		aspect = _item
		$AspectIcon.texture = aspect.icon
