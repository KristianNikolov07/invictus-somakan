extends Node

var items : Array[Item]
var weapon1 : Item
var weapon2 : Item
var weapon1_aspects : Array[Item]
var weapon2_aspects : Array[Item]
var consumables : Array[Item]
var unlocked_recipes : Array[Recipe]
var unlocked_weapons : Array[Item]
var scrap: int = 1000000

func _ready() -> void:
	unlocked_recipes.append(load("res://Recipes/fire_aspect.tres"))

	
	items.resize(5)
	weapon1_aspects.resize(2)
	weapon2_aspects.resize(2)
	consumables.resize(2)

func remove_item(item : Item, amount:= 1):
	for i in range(items.size()):
		if items[i] != null:
			if items[i].item_name == item.item_name:
				items[i].amount -= amount
				if items[i].amount <= 0:
					items[i] = null

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

func set_weapon1(weapon: Item):
	weapon1 = weapon
	
func set_weapon2(weapon: Item):
	weapon2 = weapon
	
func unlock_weapon(weapon: Item):
	for w in unlocked_weapons:
		if w.item_name == weapon.item_name:
			return
	unlocked_weapons.append(weapon)

func unlock_blueprint(blueprint : Blueprint):
	for recipe in unlocked_recipes:
		if recipe.id == blueprint.recipe.id:
			return
	unlocked_recipes.append(blueprint.recipe)
	remove_item(blueprint)

func unlock_all_blueprints():
	for item in items:
		if item != null:
			if item.type == Item.Type.BLUEPRINT:
				unlock_blueprint(item)

