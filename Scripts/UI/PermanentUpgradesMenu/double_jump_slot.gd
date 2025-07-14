extends Control

func _ready() -> void:
	set_focus_mode(FOCUS_ALL)

func check_upgradable():
	return not PlayerStats.has_double_jump and PlayerStats.souls >= 500

func get_price():
	return 500
	
func upgrade():
	PlayerStats.has_double_jump = true
	get_node("../../../../../").jumps_remaining = 1

func refresh():
	print("refreshing")
	$Price.text = "500" if not PlayerStats.has_double_jump else "Unlocked"
	$FromTo.text = "Unlocks Double Jump"
	$Price.add_theme_color_override("font_color", Color.WHITE if check_upgradable() else Color.DIM_GRAY)

func _on_texture_button_pressed() -> void:
	get_node("../../../").select_slot(self)

func _on_focus_entered() -> void:
	$Background.hide()
	$SelectedBackground.show()

func _on_focus_exited() -> void:
	$SelectedBackground.hide()
	$Background.show()
