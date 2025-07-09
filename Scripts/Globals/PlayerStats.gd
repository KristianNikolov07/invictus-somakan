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
	set_weapon1(load("res://Items/Weapons/Claws.tres"))
	items.resize(5)
	weapon1_aspects.resize(2)
	weapon2_aspects.resize(2)
	consumables.resize(2)

func add_item(_item: Item, amount:= 1):
	for i in range(items.size()):
		if items[i] == null:
			items[i] = _item
			items[i].amount = amount
			return true
		elif items[i].item_name == _item.item_name:
			items[i].amount += amount
			return true
	return false

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

func set_aspect(weaponNum: int, slot: int, aspect: Item):
	if weaponNum == 1:
		weapon1_aspects[slot] = aspect
	elif weaponNum == 2:
		weapon2_aspects[slot] = aspect

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

func add_consumable(slot: int, consumable: Item, amount:= 1):
	if consumables[slot] == null:
		consumables[slot] = consumable
		consumables[slot].amount = amount
	else:
		consumables[slot].amount += amount

func remove_consumable(slot: int, amount:= 1):
	if consumables[slot] != null:
		consumables[slot].amount -= amount
		if consumables[slot].amount <= 0:
			consumables[slot] = null
