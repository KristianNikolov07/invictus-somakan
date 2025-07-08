extends Node

var items : Array[Item]
var weapon1 : Item
var weapon2 : Item
var weapon1_aspects : Array[Item]
var weapon2_aspects : Array[Item]
var consumables : Array[Item]
var unlocked_recipes : Array[Recipe]
var scrap: int = 1000000

func _ready() -> void:
	unlocked_recipes.append(load("res://Recipes/fire_aspect.tres"))
	weapon1 = load("res://Items/Weapons/Mace.tres")
	weapon2 = load("res://Items/Weapons/DamageCircle.tres")
	
	items.resize(5)
	weapon1_aspects.resize(2)
	weapon2_aspects.resize(2)
	consumables.resize(2)

func check_item(item: Item, amount: int):
	for current_item in items:
		if current_item != null:
			if item.item_name == current_item.item_name and amount <= current_item.amount:
				return true
	return false
	
func get_item_quantity(item: Item):
	for current_item in items:
		if current_item != null:
			if item.item_name == current_item.item_name:
				return current_item.amount
	return 0
	
func is_inventory_full():
	for current_item in items:
		if current_item == null:
			return false
	return true
