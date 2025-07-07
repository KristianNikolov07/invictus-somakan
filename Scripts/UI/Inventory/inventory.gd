extends Control

var item_slot: Control = null
var is_equipped = false

const dropped_item_scene = preload("res://Scenes/Objects/dropped_item.tscn")

func _ready() -> void:
	var item = load("res://Items/fire_orb.tres")
	$Slots/ItemSlot1.set_item(item)
	item = load("res://Items/ice_orb.tres")
	$Slots/ItemSlot2.set_item(item)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Inventory"):
		visible = !visible

func add_item(item: Item):
	if item != null:
		for slot in $Slots.get_children():
			if slot.item == null:
				slot.set_item(item)
				return true
			elif slot.item.item_name == item.item_name:
				print("aaa")
				slot.increase_amount()
				return true
	return false



func refresh() -> void:
	$OptionsMenu/Equip1.disabled = true
	$OptionsMenu/Equip2.disabled = true
	$OptionsMenu/Drop.disabled = true
	$OptionsMenu/Unequip.disabled = true
	$OptionsMenu/Item.texture = null
	$OptionsMenu/Label.text = ""
	item_slot = null


func show_item_options(_item_slot: Control, _is_equipped: bool):
	refresh()
	is_equipped = _is_equipped
	item_slot = _item_slot
	var item = item_slot.item
	$OptionsMenu/Item.texture = item.icon
	$OptionsMenu/Label.text = item.item_name
	$OptionsMenu/Drop.disabled = false
	if is_equipped:
		$OptionsMenu/Unequip.disabled = false
		return
	
	if item.type == Item.Type.CONSUMABLE:
		if $Consumables/Slot1.consumable != null and $Consumables/Slot1.consumable != item_slot.item:
			$OptionsMenu/Equip1.disabled = false
		if $Consumables/Slot2.consumable != null and $Consumables/Slot2.consumable != item_slot.item:
			$OptionsMenu/Equip2.disabled = false
	elif item.type == Item.Type.ASPECT:
		if ($AspectSlots1/Slot1.aspect != item_slot.item and $AspectSlots1/Slot2.aspect != item_slot.item) or ($AspectSlots1/Slot1.aspect != null and $AspectSlots1/Slot1.aspect == null):
			$OptionsMenu/Equip1.disabled = false
		if ($AspectSlots2/Slot1.aspect != item_slot.item and $AspectSlots2/Slot2.aspect != item_slot.item) or ($AspectSlots2/Slot1.aspect != null and $AspectSlots2/Slot1.aspect == null):
			$OptionsMenu/Equip2.disabled = false


func _on_equip_1_pressed() -> void:
	if item_slot.item.type == Item.Type.CONSUMABLE:
		$Consumables/Slot1.set_consumable(item_slot.item)
	else:
		if $AspectSlots1/Slot1.aspect == null:
			$AspectSlots1/Slot1.set_aspect(item_slot.item)
		elif $AspectSlots1/Slot2.aspect == null:
			$AspectSlots1/Slot2.set_aspect(item_slot.item)
	
	item_slot.decrease_amount()
	refresh()

func _on_equip_2_pressed() -> void:
	if item_slot.item.type == Item.Type.CONSUMABLE:
		$Consumables/Slot2.set_consumable(item_slot.item)
	else:
		if $AspectSlots2/Slot1.aspect == null:
			$AspectSlots2/Slot1.set_aspect(item_slot.item)
		elif $AspectSlots2/Slot2.aspect == null:
			$AspectSlots2/Slot2.set_aspect(item_slot.item)
	
	item_slot.decrease_amount()
	refresh()


func _on_drop_pressed() -> void:
	if item_slot != null and item_slot.item != null:
		var node = dropped_item_scene.instantiate()
		node.set_item(item_slot.item.duplicate())
		node.global_position = get_node("../../").global_position
		get_node("../../../").add_child(node)
		item_slot.decrease_amount()
		
