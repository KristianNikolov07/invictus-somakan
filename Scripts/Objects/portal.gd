extends Area2D

@export_subgroup("Stage Transitions")
@export var is_stage_transition = false
@export var next_stage : Stages.Stages

@export_subgroup("Room Transitions")
@export var room_type : RoomTypes.RoomTypes

func _ready() -> void:
	if RoomGen.current_room == 5:
		room_type = RoomTypes.RoomTypes.SHOP

func interact(_player_path : String):
	
	if is_stage_transition:
		RoomGen.fill_rooms(next_stage)
		
	match room_type:
		RoomTypes.RoomTypes.PUZZLE:
			change_level.rpc(RoomGen.pull_puzzle_room().resource_path)
		RoomTypes.RoomTypes.COMBAT:
			change_level.rpc(RoomGen.pull_combat_room().resource_path)
		RoomTypes.RoomTypes.SHOP:
			change_level.rpc(RoomGen.get_shop_room().resource_path)
		RoomTypes.RoomTypes.BOSS:
			change_level.rpc(RoomGen.get_boss_room().resource_path)
		RoomTypes.RoomTypes.HUB:
			change_level.rpc(RoomGen.get_hub().resource_path)

@rpc("any_peer", "call_local", "reliable")
func change_level(level : String):
	get_tree().change_scene_to_file(level)

func activate():
	show()
	monitoring = true
