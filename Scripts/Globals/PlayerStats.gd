extends Node

var items : Array[Item]
var weapon1 : Item
var weapon2 : Item
var weapon1_aspects : Array[Item]
var weapon2_aspects : Array[Item]
var consumables : Array[Item]
var unlocked_recipes : Array[Recipe]
var scrap: int = 0

func _ready() -> void:
	unlocked_recipes.append(load("res://Recipes/fire_aspect.tres"))
	items.resize(5)
	weapon1_aspects.resize(2)
	weapon2_aspects.resize(2)
	consumables.resize(2)

func check_item(item: Item, amount: int):
	for current_item in items:
		if item.item_name == current_item.item_name and amount >= current_item.amount:
			return true
	return false
	
func get_item_quantity(item: Item):
	for current_item in items:
		if item.item_name == current_item.item_name:
			return current_item.amount
	return 0
	
