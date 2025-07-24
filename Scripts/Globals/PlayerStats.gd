extends Node

var items : Array[Item]
var weapon1 : WeaponItem
var weapon2 : WeaponItem
var weapon1_aspects : Array[Item]
var weapon2_aspects : Array[Item]
var consumables : Array[ConsumableItem]
var unlocked_recipes : Array[Recipe]
var unlocked_weapons : Array[WeaponItem]
var has_double_jump: bool = false
var scrap: int = 0
var souls: int = 0
var hp: int = 50
var max_hp: int = 50
var is_multiplayer = false
var current_save_file = 1

var config = ConfigFile.new()

func _ready() -> void:
	
	#unlocked_recipes.append(load("res://Recipes/fire_aspect.tres"))
	#set_weapon1(load("res://Items/Weapons/Marksman.tres"))
	#set_weapon2(load("res://Items/Weapons/Bow.tres"))
	items.resize(5)
	weapon1_aspects.resize(2)
	weapon2_aspects.resize(2)
	consumables.resize(2)
	
	#weapon1_aspects[1] = load("res://Items/Aspects/CriticalDamage.tres")
	#weapon1_aspects[0] = load("res://Items/Aspects/Fire.tres")
	#weapon2_aspects[1] = load("res://Items/Aspects/CriticalDamage.tres")
	#weapon2_aspects[0] = load("res://Items/Aspects/Fire.tres")
	#add_item(load("res://Items/Consumables/leech.tres"))

func add_scrap(_scrap : int):
	scrap += _scrap

func remove_scrap(_scrap : int):
	scrap -= _scrap
	scrap = 0

func get_player():
	if !is_multiplayer:
		return get_tree().get_first_node_in_group("Players")

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
	if item != null:
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
	if get_player() != null:
		get_player().instantiate_weapon_1(weapon1)
		get_player().get_node("UI/SelectedWeaponUI").set_weapon_1(PlayerStats.weapon1)
	
func set_weapon2(weapon: Item):
	weapon2 = weapon
	if get_player() != null:
		get_player().instantiate_weapon_2(weapon2)
		get_player().get_node("UI/SelectedWeaponUI").set_weapon_2(PlayerStats.weapon2)

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

func add_consumable(slot: int, consumable: ConsumableItem, amount:= 1):
	if consumables[slot] == null:
		consumables[slot] = consumable
		consumables[slot].amount = amount
		var node = consumable.consumable_action.instantiate()
		node.name = str(slot + 1)
		get_player().get_node("Consumables").add_child(node)
	elif consumables[slot].item_name == consumable.item_name:
		consumables[slot].amount += amount

func remove_consumable(slot: int, amount:= 1):
	if consumables[slot] != null:
		consumables[slot].amount -= amount
		if consumables[slot].amount <= 0:
			consumables[slot] = null
			if get_player().get_node("Consumables").get_node(str(slot + 1)) != null:
				get_player().get_node("Consumables").get_node(str(slot + 1)).queue_free()

func save_stats(saveNum: int):
	config.load_encrypted_pass("user://save" + str(saveNum) + ".save", "cursedgodotisntrealhecanthurtyou")
	config.set_value("save", "souls", souls)
	config.set_value("save", "recipes", unlocked_recipes)
	config.set_value("save", "weapons", unlocked_weapons)
	config.set_value("save", "max_hp", max_hp)
	config.set_value("save", "double_jump", has_double_jump)
	config.save_encrypted_pass("user://save" + str(saveNum) + ".save", "cursedgodotisntrealhecanthurtyou")

func load_stats(saveNum: int):
	config.load_encrypted_pass("user://save" + str(saveNum) + ".save", "cursedgodotisntrealhecanthurtyou")
	if config.has_section_key("save", "souls"):
		souls = config.get_value("save", "souls")
	if config.has_section_key("save", "recipes"):
		unlocked_recipes = config.get_value("save", "recipes")
	if config.has_section_key("save", "weapons"):
		unlocked_weapons = config.get_value("save", "weapons")
	if config.has_section_key("save", "max_hp"):
		max_hp = config.get_value("save", "max_hp")
		hp = max_hp
	if config.has_section_key("save", "double_jump"):
		has_double_jump = config.get_value("save", "double_jump")
	
	current_save_file = saveNum

func read_save_file(saveNum: int):
	if FileAccess.file_exists("user://save" + str(saveNum) + ".save"):
		config.load_encrypted_pass("user://save" + str(saveNum) + ".save", "cursedgodotisntrealhecanthurtyou")
		var stats = {
			"souls" : int(config.get_value("save", "souls")),
			"numWeapons" : config.get_value("save", "weapons").size(),
			"numRecipes" : config.get_value("save", "recipes").size(),
			"max_hp": int(config.get_value("save", "max_hp")),
			"double_jump": config.get_value("save", "double_jump")
		}
		
		return stats
	else:
		return {}

func delete_save_file(saveNum: int):
	DirAccess.remove_absolute("user://save" + str(saveNum) + ".save")
