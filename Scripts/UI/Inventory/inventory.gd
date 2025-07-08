extends Control

var item_slot: Control = null
var is_equipped = false

const dropped_item_scene = preload("res://Scenes/Objects/dropped_item.tscn")

func _ready() -> void:
	$Slots/ItemSlot1.item.amount = 3
	$Slots/ItemSlot2.item.amount = 3
	for i in range($Slots.get_children().size()):
		$Slots.get_children()[i].set_item(PlayerStats.items[i]) 
		
	$WeaponSlots/Slot1.set_weapon(PlayerStats.weapon1)
	$WeaponSlots/Slot2.set_weapon(PlayerStats.weapon2)
	
	for i in range($AspectSlots1.get_children().size()):
		$AspectSlots1.get_children()[i].set_aspect(PlayerStats.weapon1_aspects[i]) 
		
	for i in range($AspectSlots2.get_children().size()):
		$AspectSlots2.get_children()[i].set_aspect(PlayerStats.weapon2_aspects[i]) 
		
	for i in range($Consumables.get_children().size()):
		$Consumables.get_children()[i].set_consumable(PlayerStats.consumables[i]) 


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Inventory"):
		visible = !visible


func add_item(item: Item, amount:= 1):
	if item != null:
		for slot in $Slots.get_children():
			if slot.item == null:
				slot.set_item(item.duplicate())
				update_globals()
				return true
			elif slot.item.item_name == item.item_name:
				slot.increase_amount(amount)
				update_globals()
				return true
		
	return false

func remove_item(item: Item, amount:= 1):
	if item != null:
		for slot in $Slots.get_children():
			if slot.item != null:
				if slot.item.item_name == item.item_name:
					slot.decrease_amount(amount)

func update_globals():
	for i in range($Slots.get_children().size()):
		PlayerStats.items[i] = $Slots.get_children()[i].item
		
	PlayerStats.weapon1 = $WeaponSlots/Slot1.weapon
	PlayerStats.weapon2 = $WeaponSlots/Slot2.weapon
	
	for i in range($AspectSlots1.get_children().size()):
		PlayerStats.weapon1_aspects[i] = $AspectSlots1.get_children()[i].aspect
		
	for i in range($AspectSlots2.get_children().size()):
		PlayerStats.weapon2_aspects[i] = $AspectSlots2.get_children()[i].aspect
		
	for i in range($Consumables.get_children().size()):
		PlayerStats.consumables[i] = $Consumables.get_children()[i].consumable

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
		if $Consumables/Slot1.consumable == null or ($Consumables/Slot1.consumable.item_name == item_slot.item.item_name):
			$OptionsMenu/Equip1.disabled = false
		if $Consumables/Slot2.consumable == null or ($Consumables/Slot2.consumable.item_name == item_slot.item.item_name):
			$OptionsMenu/Equip2.disabled = false
	elif item.type == Item.Type.ASPECT:
		if ($AspectSlots1/Slot1.aspect == null or $AspectSlots1/Slot2.aspect == null) and ((($AspectSlots1/Slot1.aspect.item_name if $AspectSlots1/Slot1.aspect != null else "") != item_slot.item.item_name) and (($AspectSlots1/Slot2.aspect.item_name if $AspectSlots1/Slot2.aspect != null else "") != item_slot.item.item_name)):
			$OptionsMenu/Equip1.disabled = false
		if ($AspectSlots2/Slot1.aspect == null or $AspectSlots2/Slot2.aspect == null) and ((($AspectSlots2/Slot1.aspect.item_name if $AspectSlots2/Slot1.aspect != null else "") != item_slot.item.item_name) and (($AspectSlots2/Slot2.aspect.item_name if $AspectSlots2/Slot2.aspect != null else "") != item_slot.item.item_name)):
			$OptionsMenu/Equip2.disabled = false

func _on_equip_1_pressed() -> void:
	if item_slot.item.type == Item.Type.CONSUMABLE:
		if $Consumables/Slot1.consumable == null:
			$Consumables/Slot1.set_consumable(item_slot.item)
		else:
			$Consumables/Slot1.increase_amount()
	else:
		if $AspectSlots1/Slot1.aspect == null:
			$AspectSlots1/Slot1.set_aspect(item_slot.item)
		elif $AspectSlots1/Slot2.aspect == null:
			$AspectSlots1/Slot2.set_aspect(item_slot.item)
	
	item_slot.decrease_amount()
	update_globals()
	refresh()

func _on_equip_2_pressed() -> void:
	if item_slot.item.type == Item.Type.CONSUMABLE:
		if $Consumables/Slot2.consumable == null:
			$Consumables/Slot2.set_consumable(item_slot.item)
		else:
			$Consumables/Slot2.increase_amount()
	else:
		if $AspectSlots2/Slot1.aspect == null:
			$AspectSlots2/Slot1.set_aspect(item_slot.item)
		elif $AspectSlots2/Slot2.aspect == null:
			$AspectSlots2/Slot2.set_aspect(item_slot.item)
	
	item_slot.decrease_amount()
	refresh()
	update_globals()


func _on_drop_pressed() -> void:
	var check_item: Item = null
	if item_slot.get_parent().name == "Slots":
		check_item = item_slot.item
	elif item_slot.get_parent().name == "Consumables":
		check_item = item_slot.consumable
	else:
		check_item = item_slot.aspect
	
	if item_slot != null and check_item != null:
		var node = dropped_item_scene.instantiate()
		node.get_node("Area").set_item(check_item.duplicate())
		node.global_position = get_node("../../").global_position
		get_node("../../../").add_child(node)
		check_item.amount -= 1
		print("Count: " + str(check_item.amount))
		if check_item.amount <= 0: check_item = null
		if check_item == null:
			item_slot.clear_item()
			refresh()
 
func _on_unequip_pressed() -> void:
	if item_slot.get_parent().name == "Consumables":
		add_item(item_slot.consumable)
		item_slot.take_item()
		if item_slot.consumable == null:
			refresh()
	else:
		add_item(item_slot.aspect)
		item_slot.take_item()
		if item_slot.aspect == null:
			refresh()
	update_globals()
