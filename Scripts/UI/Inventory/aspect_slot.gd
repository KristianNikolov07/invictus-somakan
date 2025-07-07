extends Control

@export var aspect: Item


func set_aspect(_item: Item) -> void:
	aspect = _item
	$AspectIcon.texture = aspect.icon

func take_item():
	if aspect != null:
		aspect.amount -= 1
		if aspect.amount <= 0:
			clear()

func clear():
	$ConsumableIcon.texture = null
	aspect = null
