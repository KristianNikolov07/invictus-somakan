extends Control

const crafting_slot_scene = preload("res://Scenes/UI/Crafting/crafting_slot.tscn")

var selected_slot: Control = null

func _ready():
	refresh()
		
func check_craftable(recipe: Recipe):
	return PlayerStats.scrap >= recipe.price \
	and PlayerStats.check_item(recipe.item, recipe.amount) \
	and not PlayerStats.is_inventory_full()

func refresh():
	select_slot(null)
	for child in $ScrollContainer/VBoxContainer.get_children():
		child.queue_free()
	for recipe in PlayerStats.unlocked_recipes:
		var current_slot = crafting_slot_scene.instantiate()
		$ScrollContainer/VBoxContainer.add_child(current_slot)
		current_slot.set_recipe(recipe)
	$ScrapAmount.text = str(PlayerStats.scrap)
	
func select_slot(slot: Control):
	if slot != null:
		slot.grab_focus()
		selected_slot = slot
		slot.refresh()
		var _recipe = slot.get_recipe()
		if check_craftable(slot.get_recipe()):
			$CraftButton.disabled = false
		else:
			$CraftButton.disabled = true
	else:
		selected_slot = null
		$CraftButton.disabled = true

func _on_exit_button_pressed() -> void:
	hide()

func _on_craft_button_pressed() -> void:
	if (not PlayerStats.is_inventory_full() or PlayerStats.check_item(selected_slot.get_recipe().result, 1)) and PlayerStats.scrap >= selected_slot.get_recipe().price:
		PlayerStats.remove_item(selected_slot.get_recipe().item, selected_slot.get_recipe().amount)
		PlayerStats.add_item(selected_slot.get_recipe().result, selected_slot.get_recipe().result_amount)
		PlayerStats.scrap -= selected_slot.get_recipe().price
		refresh()
		
		
