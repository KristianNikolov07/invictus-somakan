extends Control

var item: Item
@export var is_selling = false

func set_item(_item: Item):
	item = _item
	$Item.texture = item.icon
	$Price.text = str(item.price)
	$ItemName.text = item.item_name
	$Scrap.show()
	refresh_price_color()

func clear_item():
	item = null
	$Item.texture = null
	$Price.text = ""
	$ItemName.text = ""
	$Scrap.hide()

func reset_bg_color():
	$BG.color = Color(0, 0, 0, 1)

func refresh_price_color():
	if item != null:
		if PlayerStats.scrap < item.price and !is_selling:
			$Price.self_modulate = Color(1, 0, 0, 1)
		else:
			$Price.self_modulate = Color(1, 1, 1, 1)


func _on_texture_button_pressed() -> void:
	if item != null:
		for button in get_parent().get_children():
			button.reset_bg_color()
		
		get_node("../../").select(item, int(str(name)[-1])-1)
		$BG.color = Color(0.3, 0.3, 0.3, 1)
