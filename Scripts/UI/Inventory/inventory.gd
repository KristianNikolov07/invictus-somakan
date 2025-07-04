extends Control

var item_slot: Control = null


func _ready() -> void:
	var item = load("res://Items/fire_orb.tres")
	$Slots/ItemSlot1.set_item(item)
	item = load("res://Items/ice_orb.tres")
	$Slots/ItemSlot2.set_item(item)


func show_item_options(_item_slot: Control):
	item_slot = _item_slot
	var item = item_slot.item
	$OptionsMenu/Item.texture = item.icon
	$OptionsMenu/Label.text = item.item_name
	$OptionsMenu/Drop.disabled = false
	if item.type == Item.Type.CONSUMABLE:
		$OptionsMenu/Equip1.disabled = false
		$OptionsMenu/Equip2.disabled = false
	elif item.type == Item.Type.ASPECT:
		$OptionsMenu/Equip1.disabled = false
		$OptionsMenu/Equip2.disabled = false
