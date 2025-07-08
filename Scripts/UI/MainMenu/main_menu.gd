extends Control


func _on_play_pressed() -> void:
	$Play.enabled = true


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	$Play.enabled = false


func _on_play_save_pressed() -> void:
	#TODO: Add savefile loading
	$Play.enabled = false
	$SingleplayerOrMultiplayer.enabled = true


func _on_delete_save_pressed() -> void:
	pass # Replace with function body.


func _on_save_1_pressed() -> void:
	$Play/SaveInfo.show()
	$Play/ActionButtons/DeleteSave.disabled = false
	$Play/ActionButtons/PlaySave.disabled = false
	


func _on_save_2_pressed() -> void:
	$Play/SaveInfo.show()
	$Play/ActionButtons/DeleteSave.disabled = false
	$Play/ActionButtons/PlaySave.disabled = false


func _on_save_3_pressed() -> void:
	$Play/SaveInfo.show()
	$Play/ActionButtons/DeleteSave.disabled = false
	$Play/ActionButtons/PlaySave.disabled = false


func _on_back_to_saves_pressed() -> void:
	$Play.enabled = true
	$SingleplayerOrMultiplayer.enabled = false


func _on_singleplayer_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Rooms/Start/start_room.tscn")


func _on_multiplayer_pressed() -> void:
	pass # Replace with function body.
