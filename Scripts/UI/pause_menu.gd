extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if visible:
			get_tree().paused = false
			hide()
		else:
			get_tree().paused = true
			show()


func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_back_to_hub_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Rooms/Hub/hub.tscn")


func _on_back_to_menu_pressed() -> void:
	PlayerStats.save_stats(PlayerStats.current_save_file)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu/main_menu.tscn")
