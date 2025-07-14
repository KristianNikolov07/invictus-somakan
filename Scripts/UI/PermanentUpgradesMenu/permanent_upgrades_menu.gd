extends Control

var selected_slot: Control = null

func _ready():
	refresh()

func refresh():
	select_slot(null)
	for child in $ScrollContainer/VBoxContainer.get_children():
		child.refresh()
	$SoulsAmount.text = str(PlayerStats.souls)
	
func select_slot(slot: Control):
	if slot != null:
		slot.grab_focus()
		selected_slot = slot
		slot.refresh()
		if slot.check_upgradable():
			$UpgradeButton.disabled = false
		else:
			$UpgradeButton.disabled = true
	else:
		selected_slot = null
		$UpgradeButton.disabled = true

func _on_exit_button_pressed() -> void:
	hide()

func _on_upgrade_button_pressed() -> void:
	if selected_slot.check_upgradable():
		PlayerStats.souls -= selected_slot.get_price()
		selected_slot.upgrade()
		refresh()	
		
