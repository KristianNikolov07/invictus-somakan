@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("ScreenShake2D", "Node2D", preload("res://addons/screen_shaker/screen_shake.gd"), preload("res://addons/screen_shaker/shake_icon.png"))


func _exit_tree() -> void:
	remove_custom_type("ScreenShake2D")
