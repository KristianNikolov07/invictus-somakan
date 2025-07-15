extends Area2D
@export var weapon: WeaponItem
@export var unlocked = false

func _ready() -> void:
	unlock()
	if unlocked:
		show()
	else:
		hide()

func unlock():
	for w in PlayerStats.unlocked_weapons:
		if w != null:
			if w.item_name == weapon.item_name:
				unlocked = true

func interact(player_path : String):
	if unlocked:
		var player = get_node(player_path)
		if PlayerStats.weapon1 == null:
			PlayerStats.set_weapon1(weapon)
			player.switch_weapon(weapon)
		elif PlayerStats.weapon2 == null and PlayerStats.weapon1.item_name != weapon.item_name:
			PlayerStats.set_weapon2(weapon)
			player.switch_weapon(weapon)
