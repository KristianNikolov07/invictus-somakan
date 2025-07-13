extends Node2D

func _ready() -> void:
	PlayerStats.save_stats(PlayerStats.current_save_file)
