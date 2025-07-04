extends Control

@export var aspect: Item


func set_aspect(_item: Item) -> void:
	aspect = _item
	$AspectIcon.texture = aspect.icon
