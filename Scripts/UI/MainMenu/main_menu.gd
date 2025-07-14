extends Control
var selected_save : int

func _on_play_pressed() -> void:
	$Play.enabled = true


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	$Play.enabled = false


func _on_play_save_pressed() -> void:
	$Play.enabled = false
	$SingleplayerOrMultiplayer.enabled = true


func _on_delete_save_pressed() -> void:
	$Play/Saves/Save1.hide()
	$Play/Saves/Save2.hide()
	$Play/Saves/Save3.hide()
	$Play/SaveInfo.hide()
	$Play/DeleteConfirm.show()


func _on_save_1_pressed() -> void:
	selected_save = 1
	var save_info = PlayerStats.read_save_file(1)
	display_save_info(save_info)

func _on_save_2_pressed() -> void:
	selected_save = 2
	var save_info = PlayerStats.read_save_file(2)
	display_save_info(save_info)


func _on_save_3_pressed() -> void:
	selected_save = 3
	var save_info = PlayerStats.read_save_file(3)
	display_save_info(save_info)

func display_save_info(save_info : Dictionary):
	$Play/ActionButtons/PlaySave.disabled = false
	if !save_info.is_empty():
		$Play/SaveInfo.show()
		$Play/ActionButtons/DeleteSave.disabled = false
		$Play/SaveInfo/Souls.text = "Souls: " + str(save_info.souls)
		$Play/SaveInfo/UnlockedWeapons.text = "Weapons: " + str(save_info.numWeapons)
		$Play/SaveInfo/UnlockedRecipes.text = "Recipes: " + str(save_info.numRecipes)
	else:
		$Play/SaveInfo.hide()
		$Play/ActionButtons/DeleteSave.disabled = true

func _on_back_to_saves_pressed() -> void:
	$Play.enabled = true
	$SingleplayerOrMultiplayer.enabled = false


func _on_singleplayer_pressed() -> void:
	PlayerStats.load_stats(selected_save)
	PlayerStats.is_multiplayer = false
	get_tree().change_scene_to_file("res://Scenes/Rooms/Hub/hub.tscn")


func _on_multiplayer_pressed() -> void:
	pass # Replace with function body.


func _on_confirm_delete_pressed() -> void:
	PlayerStats.delete_save_file(selected_save)
	_on_abort_delete_pressed()


func _on_abort_delete_pressed() -> void:
	$Play/Saves/Save1.show()
	$Play/Saves/Save2.show()
	$Play/Saves/Save3.show()
	$Play/SaveInfo.show()
	$Play/DeleteConfirm.hide()
