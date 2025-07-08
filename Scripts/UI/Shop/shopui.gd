extends Control

var selected_item: Item = null
var is_buying := true


func _on_buy_button_pressed() -> void:
	$BuyButton.modulate = Color(1, 1, 1, 1)
	$SellButton.modulate = Color(0.6, 0.6, 0.6, 1)
	$ItemsToBuy.show()
	$ItemsToSell.hide()


func _on_sell_button_pressed() -> void:
	$BuyButton.modulate = Color(0.6, 0.6, 0.6, 1)
	$SellButton.modulate = Color(1, 1, 1, 1)
	$ItemsToBuy.hide()
	$ItemsToSell.show()


func _on_act_button_pressed() -> void:
	if is_buying:
		PlayerStats.scrap -= selected_item.price
		for button in get_children():
			button.refresh_price_color()
		
		get_node("../../").add_item(selected_item)


func _on_exit_button_pressed() -> void:
	hide()

func set_confirm_status(enabled: bool):
	if enabled:
		$ActButton.disabled = false
		$ActButton.modulate = Color(0.6, 0.6, 0.6, 1)
	else:
		$ActButton.disabled = true
		$ActButton.modulate = Color(1, 1, 1, 1)

func select(item: Item, _is_buying: bool):
	selected_item = item
	is_buying = _is_buying
	if selected_item.price > PlayerStats.scrap:
		set_confirm_status(false)
	else:
		set_confirm_status(true)

func add_buttons():
	pass
