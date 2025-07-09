extends Control

var selected_index: int = -1
var selected_item: Item = null
var is_buying := true


func _ready() -> void:
	add_buttons()


func _on_buy_button_pressed() -> void:
	is_buying = true
	$BuyButton.modulate = Color(1, 1, 1, 1)
	$SellButton.modulate = Color(0.6, 0.6, 0.6, 1)
	$ItemsToBuy.show()
	$ItemsToSell.hide()


func _on_sell_button_pressed() -> void:
	is_buying = false
	$BuyButton.modulate = Color(0.6, 0.6, 0.6, 1)
	$SellButton.modulate = Color(1, 1, 1, 1)
	$ItemsToBuy.hide()
	$ItemsToSell.show()


func _on_act_button_pressed() -> void:
	if is_buying:
		PlayerStats.scrap -= selected_item.price
		for button in $ItemsToBuy.get_children():
			button.refresh_price_color()
		
		var new_item: RigidBody2D = load("res://Scenes/Objects/dropped_item.tscn").instantiate()
		new_item.global_position = get_node("../../").global_position
		new_item.get_child(1).set_item(selected_item.duplicate())
		get_tree().current_scene.add_child(new_item)
		#get_node("../Inventory").add_item(selected_item)
	else:
		var node = get_node("../Inventory/Slots").get_child(selected_index)
		if node.item != null:
			PlayerStats.scrap += node.item.price/2
			node.decrease_amount()
			if node.item == null:
				set_confirm_status(false)
				$ItemsToSell.get_child(selected_index).reset_bg_color()
			refresh_sell()


func _on_exit_button_pressed() -> void:
	hide()

func set_confirm_status(enabled: bool):
	if enabled:
		$ActButton.disabled = false
		$ActButton.modulate = Color(1, 1, 1, 1)
	else:
		$ActButton.disabled = true
		$ActButton.modulate = Color(0.6, 0.6, 0.6, 1)

func select(item: Item, index: int):
	selected_index = index
	selected_item = item
	if selected_item.price > PlayerStats.scrap:
		set_confirm_status(false)
	else:
		set_confirm_status(true)

func add_buttons():
	$ItemsToBuy/ShopSlot1.set_item(load("res://Items/Consumables/healing_vial.tres"))
	$ItemsToBuy/ShopSlot2.set_item(load("res://Items/Consumables/healing_potion.tres"))
	$ItemsToBuy/ShopSlot3.set_item(load("res://Items/Consumables/healing_barrel.tres"))
	
	refresh_sell()


func refresh_sell():
	var item_slots: Control = get_node("../Inventory/Slots")
	var index = 1
	for slot: Control in item_slots.get_children():
		if slot.item != null:
			get_node("ItemsToSell/ShopSlot" + str(index)).set_item(slot.item)
			get_node("ItemsToSell/ShopSlot" + str(index) + "/ItemName").text += "   " + str(slot.item.amount) + "x"
			get_node("ItemsToSell/ShopSlot" + str(index) + "/Price").text = str(int(get_node("ItemsToSell/ShopSlot" + str(index) + "/Price").text)/2)
		else:
			get_node("ItemsToSell/ShopSlot" + str(index)).clear_item()
		index += 1
