extends Control

var recipe: Recipe = null

func _ready() -> void:
	set_focus_mode(FOCUS_ALL)

func refresh():
	print("refreshing")
	$ItemIcon.texture = recipe.result.icon
	$AmountCrafted.text = str(recipe.result_amount)
	$Name.text = recipe.result.item_name
	$Price.text = str(recipe.price)
	$NeededItem.texture = recipe.item.icon
	$NeededItemQuantity.text = str(PlayerStats.get_item_quantity(recipe.item)) + "/" + str(recipe.amount)
	$NeededItemQuantity.add_theme_color_override("font_color", Color.DIM_GRAY if PlayerStats.check_item(recipe.item, recipe.amount) == false else Color.WHITE)

func get_recipe():
	return recipe
	
func set_recipe(new_recipe: Recipe):
	recipe = new_recipe
	refresh()

func _on_texture_button_pressed() -> void:
	get_node("../../../").select_slot(self)

func _on_focus_entered() -> void:
	$Background.hide()
	$SelectedBackground.show()

func _on_focus_exited() -> void:
	$SelectedBackground.hide()
	$Background.show()
