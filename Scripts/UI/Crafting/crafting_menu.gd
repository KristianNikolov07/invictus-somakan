extends Control

const crafting_slot_scene = preload("res://Scenes/UI/Crafting/crafting_slot.tscn")

var selected_slot: Control = null

func _ready():
	for recipe in PlayerStats.unlocked_recipes:
		var current_slot = crafting_slot_scene.instantiate()
		$ScrollContainer/VBoxContainer.add_child(current_slot)
		current_slot.set_recipe(recipe)
		

func refresh():
	pass
	
func select_slot(slot: Control):
	slot.grab_focus()
	selected_slot = slot
	
	
	
