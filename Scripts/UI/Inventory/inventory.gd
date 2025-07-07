extends Control

var item_slot: Control = null
var is_equipped = false

const dropped_item_scene = preload("res://Scenes/Objects/dropped_item.tscn")

func _ready() -> void:
	for i in range($Slots.get_children().size()):
		$Slots.get_children()[i].set_item(Inv.items[i]) 
		
	$WeaponSlots/Slot1.set_weapon(Inv.weapon1)
	$WeaponSlots/Slot2.set_weapon(Inv.weapon2)
	
	for i in range($AspectSlots1.get_children().size()):
		$AspectSlots1.get_children()[i].set_aspect(Inv.weapon1_aspects[i]) 
		
	for i in range($AspectSlots2.get_children().size()):
		$AspectSlots2.get_children()[i].set_aspect(Inv.weapon2_aspects[i]) 
		
	for i in range($Consumables.get_children().size()):
		$Consumables.get_children()[i].set_consumable(Inv.consumables[i]) 


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Inventory"):
		visible = !visible


func add_item(item: Item):
	if item != null:
		for slot in $Slots.get_children():
			if slot.item == null:
				slot.set_item(item)
				update_globals()
				return true
			elif slot.item.item_name == item.item_name:
				slot.increase_amount()
				update_globals()
				return true
		
	return false

func update_globals():
	for i in range($Slots.get_children().size()):
		Inv.items[i] = $Slots.get_children()[i].item
		
	Inv.weapon1 = $WeaponSlots/Slot1.weapon
	Inv.weapon2 = $WeaponSlots/Slot2.weapon
	
	for i in range($AspectSlots1.get_children().size()):
		Inv.weapon1_aspects[i] = $AspectSlots1.get_children()[i].aspect
		
	for i in range($AspectSlots2.get_children().size()):
		Inv.weapon2_aspects[i] = $AspectSlots2.get_children()[i].aspect
		
	for i in range($Consumables.get_children().size()):
		Inv.consumables[i] = $Consumables.get_children()[i].consumable

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
	
	var item
	if !is_equipped:
		item = item_slot.item
	elif item_slot.get_parent().name == "Consumables":
		item = item_slot.consumable
	else:
		item = item_slot.aspect
	
	$OptionsMenu/Item.texture = item.icon
	$OptionsMenu/Label.text = item.item_name
	$OptionsMenu/Drop.disabled = false
	if is_equipped:
		$OptionsMenu/Unequip.disabled = false
		return
	
	if item.type == Item.Type.CONSUMABLE:
		if $Consumables/Slot1.consumable == null or ($Consumables/Slot1.consumable == item_slot.item):
			$OptionsMenu/Equip1.disabled = false
		if $Consumables/Slot2.consumable == null or ($Consumables/Slot2.consumable == item_slot.item):
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
	update_globals()

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
	update_globals()


func _on_drop_pressed() -> void:
	if item_slot != null and item_slot.item != null:
		var node = dropped_item_scene.instantiate()
		node.get_node("Area").set_item(item_slot.item.duplicate())
		node.global_position = get_node("../../").global_position
		get_node("../../../").add_child(node)
		item_slot.decrease_amount()
		if item_slot.item == null:
			refresh()
 
func _on_unequip_pressed() -> void:
	if item_slot.get_parent().name == "Consumables":
		add_item(item_slot.consumable)
		item_slot.take_item()
		if item_slot.consumable == null:
			refresh()
	else:
		add_item(item_slot.aspect)
		refresh()
	update_globals()
