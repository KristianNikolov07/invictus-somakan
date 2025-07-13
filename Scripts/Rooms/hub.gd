extends Node2D

func _ready() -> void:
	PlayerStats.save_stats(PlayerStats.current_save_file)
	PlayerStats.hp = PlayerStats.max_hp
	
	PlayerStats.remove_consumable(0, 1000)
	PlayerStats.remove_consumable(1, 1000)
	
	PlayerStats.set_aspect(1, 0, null)
	PlayerStats.set_aspect(1, 1, null)
	
	PlayerStats.set_aspect(2, 0, null)
	PlayerStats.set_aspect(2, 1, null)
	
	RoomGen.current_room = 0
