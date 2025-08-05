extends Area2D
@export var weapon: WeaponItem
@export var unlocked = false

func _ready() -> void:
	if weapon.item_name == "Mace":
		$Sprite2D.play("mace")
	elif weapon.item_name == "Claws":
		$Sprite2D.play("claws")
	elif weapon.item_name == "Bow":
		$Sprite2D.play("bow")
	elif weapon.item_name == "Marksman":
		$Sprite2D.play("marksman")
	elif weapon.item_name == "Damage Circle":
		$Sprite2D.play("catalist")
	elif weapon.item_name == "Chushkopek Sniper":
		$Sprite2D.play("sniper")
	
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
