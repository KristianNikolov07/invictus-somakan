extends Control

func _ready() -> void:
	refresh()

func refresh():
	$HBoxContainer/ConsumbleUISlot1.set_item(PlayerStats.consumables[0])
	$HBoxContainer/ConsumbleUISlot2.set_item(PlayerStats.consumables[1])
