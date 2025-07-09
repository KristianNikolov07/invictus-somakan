extends Control

var item_slot: Control = null
var is_equipped = false

const dropped_item_scene = preload("res://Scenes/Objects/dropped_item.tscn")

func _ready() -> void:
	$Slots/ItemSlot1.item.amount = 3
	$Slots/ItemSlot2.item.amount = 3
	refresh()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Inventory"):
		visible = !visible
		refresh()

func refresh() -> void:
	$OptionsMenu/Equip1.disabled = true
	$OptionsMenu/Equip2.disabled = true
	$OptionsMenu/Drop.disabled = true
	$OptionsMenu/Unequip.disabled = true
	$OptionsMenu/Item.texture = null
	$OptionsMenu/Label.text = ""
	item_slot = null
	
	#display items
	for i in range($Slots.get_children().size()):
		$Slots.get_children()[i].set_item(PlayerStats.items[i]) 
	
	#display weapons
	$WeaponSlots/Slot1.set_item(PlayerStats.weapon1)
	$WeaponSlots/Slot2.set_item(PlayerStats.weapon2)
	
	#display aspects
	for i in range($AspectSlots1.get_children().size()):
		$AspectSlots1.get_children()[i].set_item(PlayerStats.weapon1_aspects[i]) 	
	for i in range($AspectSlots2.get_children().size()):
		$AspectSlots2.get_children()[i].set_item(PlayerStats.weapon2_aspects[i]) 
	
	#display consumables
	for i in range($Consumables.get_children().size()):
		$Consumables.get_children()[i].set_item(PlayerStats.consumables[i]) 


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
		$OptionsMenu/Drop.disabled = true
		return
	
	if item.type == Item.Type.CONSUMABLE:
		if $Consumables/Slot1.item == null or ($Consumables/Slot1.item.item_name == item_slot.item.item_name):
			$OptionsMenu/Equip1.disabled = false
		if $Consumables/Slot2.item == null or ($Consumables/Slot2.item.item_name == item_slot.item.item_name):
			$OptionsMenu/Equip2.disabled = false
	elif item.type == Item.Type.ASPECT:
		if ($AspectSlots1/Slot1.item == null or $AspectSlots1/Slot2.item == null) and ((($AspectSlots1/Slot1.item.item_name if $AspectSlots1/Slot1.item != null else "") != item_slot.item.item_name) and (($AspectSlots1/Slot2.item.item_name if $AspectSlots1/Slot2.item != null else "") != item_slot.item.item_name)):
			$OptionsMenu/Equip1.disabled = false
		if ($AspectSlots2/Slot1.item == null or $AspectSlots2/Slot2.item == null) and ((($AspectSlots2/Slot1.item.item_name if $AspectSlots2/Slot1.item != null else "") != item_slot.item.item_name) and (($AspectSlots2/Slot2.item.item_name if $AspectSlots2/Slot2.item != null else "") != item_slot.item.item_name)):
			$OptionsMenu/Equip2.disabled = false

func _on_equip_1_pressed() -> void:
	if item_slot.item.type == Item.Type.CONSUMABLE:
		PlayerStats.add_consumable(0, item_slot.item)
	else:
		if PlayerStats.weapon1_aspects[0] == null:
			PlayerStats.set_aspect(1, 0, item_slot.item)
		elif PlayerStats.weapon1_aspects[1] == null:
			PlayerStats.set_aspect(1, 1, item_slot.item)
	
	PlayerStats.remove_item(item_slot.item)
	refresh()

func _on_equip_2_pressed() -> void:
	if item_slot.item.type == Item.Type.CONSUMABLE:
		PlayerStats.add_consumable(1, item_slot.item)
	else:
		if PlayerStats.weapon2_aspects[0] == null:
			PlayerStats.set_aspect(2, 0, item_slot.item)
		elif PlayerStats.weapon2_aspects[1] == null:
			PlayerStats.set_aspect(2, 1, item_slot.item)
	
	PlayerStats.remove_item(item_slot.item)
	refresh()

func _on_drop_pressed() -> void:
	
	if item_slot != null and item_slot.item != null:
		var item = item_slot.item
		var node = dropped_item_scene.instantiate()
		node.get_node("Area").set_item(item.duplicate())
		node.global_position = get_node("../../").global_position
		get_node("../../../").add_child(node)
		PlayerStats.remove_item(item)
		refresh()
 
func _on_unequip_pressed() -> void:
	if item_slot.get_parent().name == "Consumables":
		PlayerStats.add_item(item_slot.item)
		if item_slot.name == "Slot1":
			PlayerStats.remove_consumable(0)
		elif item_slot.name == "Slot2":
			PlayerStats.remove_consumable(1)
		refresh()
	else:
		PlayerStats.add_item(item_slot.item)
		if item_slot.get_parent().name == "AspectSlots1":
			if item_slot.name == "Slot1":
				PlayerStats.set_aspect(1, 0, null)
			elif item_slot.name == "Slot2":
				PlayerStats.set_aspect(1, 1, null)
		elif item_slot.get_parent().name == "AspectSlots2":
			if item_slot.name == "Slot1":
				PlayerStats.set_aspect(2, 0, null)
			elif item_slot.name == "Slot2":
				PlayerStats.set_aspect(2, 1, null)
		refresh()
