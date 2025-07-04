extends Control


func _ready() -> void:
	var item = load("res://ice_orb.tres")
	$Slots/ItemSlot1.set_item(item)
	$Slots/ItemSlot3.set_item(item)


func show_item_options(item: Item):
	pass
