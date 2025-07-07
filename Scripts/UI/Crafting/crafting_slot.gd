extends Control

var recipe: Recipe = null

func refresh():
	$ItemIcon.texture = recipe.result.icon
	$AmountCrafted.text = str(recipe.result_amount)
	$Name.text = recipe.item.item_name
	$Price.text = str(recipe.price)
	$NeededItem.texture = recipe.item.icon
	$NeededItemQuantity.text = str(PlayerStats.get_item_quantity(recipe.item)) + "/" + str(recipe.amount)
	$NeededItemQuantity.label_settings.color = Color.RED

func get_recipe():
	return recipe
	
func set_recipe(new_recipe: Recipe):
	recipe = new_recipe
	refresh()

func _on_texture_button_pressed() -> void:
	get_node("../../").select_slot(self)
