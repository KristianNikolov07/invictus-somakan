extends Control

func _ready() -> void:
	set_focus_mode(FOCUS_ALL)

func check_upgradable():
	return PlayerStats.souls >= 10 * 2 ** ((PlayerStats.max_hp - 50) / 10)

func get_price():
	return 10 * 2 ** ((PlayerStats.max_hp - 50) / 10)

func upgrade():
	PlayerStats.max_hp += 10
	PlayerStats.hp += 10

func refresh():
	print("refreshing")
	$Price.text = str(10 * 2 ** ((PlayerStats.max_hp - 50) / 10))
	$FromTo.text = str(PlayerStats.max_hp) + " -> " + str(PlayerStats.max_hp + 10)
	$Price.add_theme_color_override("font_color", Color.WHITE if check_upgradable() else Color.DIM_GRAY)

func _on_texture_button_pressed() -> void:
	get_node("../../../").select_slot(self)

func _on_focus_entered() -> void:
	$Background.hide()
	$SelectedBackground.show()

func _on_focus_exited() -> void:
	$SelectedBackground.hide()
	$Background.show()
