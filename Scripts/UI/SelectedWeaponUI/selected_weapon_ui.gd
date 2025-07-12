extends HBoxContainer

func select_weapon_1():
	$Weapon1/Selected.show()
	$Weapon2/Selected.hide()

func select_weapon_2():
	$Weapon2/Selected.show()
	$Weapon1/Selected.hide()

func set_weapon_1(weapon : WeaponItem):
	$Weapon1/Icon.texture = weapon.icon

func set_weapon_2(weapon : WeaponItem):
	$Weapon2/Icon.texture = weapon.icon
