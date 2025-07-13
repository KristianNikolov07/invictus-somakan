extends Control


func _on_back_to_hub_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Rooms/Hub/hub.tscn")


func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu/main_menu.tscn")
