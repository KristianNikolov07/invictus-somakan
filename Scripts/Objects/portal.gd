extends Area2D

@export var is_first = false

@export_subgroup("Stage Transitions")
@export var is_stage_transition = false
@export var next_stage : Stages.Stages

@export_subgroup("Room Transitions")
@export var room_type : RoomTypes.RoomTypes

func _ready() -> void:
	if RoomGen.current_room == 5:
		room_type = RoomTypes.RoomTypes.SHOP
	
	if is_stage_transition:
		$Sprite2D.play("stage_transition")
	elif room_type == RoomTypes.RoomTypes.HUB:
		$Sprite2D.play("stage_transition")
	elif room_type == RoomTypes.RoomTypes.COMBAT:
		$Sprite2D.play("combat")
	elif room_type == RoomTypes.RoomTypes.SHOP:
		$Sprite2D.play("shop")
	elif room_type == RoomTypes.RoomTypes.BOSS:
		$Sprite2D.play("boss")

func interact(_player_path : String):
	if is_stage_transition:
		RoomGen.fill_rooms(next_stage)
	
	if is_first:
		var consumables = DirAccess.get_files_at("res://Items/Consumables")
		var rand = randi_range(0, consumables.size() - 1)
		PlayerStats.add_consumable(0, load("res://Items/Consumables/" + consumables[rand]))
		
		rand = randi_range(0, consumables.size() - 1)
		PlayerStats.add_consumable(1, load("res://Items/Consumables/" + consumables[rand]))
		
		#PlayerStats.set_aspect(1, 1, load("res://Items/Aspects/Fire.tres"))
		#PlayerStats.set_aspect(2, 1, load("res://Items/Aspects/Poison.tres"))

	
	match room_type:
		RoomTypes.RoomTypes.PUZZLE:
			get_tree().change_scene_to_packed(RoomGen.pull_puzzle_room())
		RoomTypes.RoomTypes.COMBAT:
			get_tree().change_scene_to_packed(RoomGen.pull_combat_room())
		RoomTypes.RoomTypes.SHOP:
			get_tree().change_scene_to_packed(RoomGen.get_shop_room())
		RoomTypes.RoomTypes.BOSS:
			get_tree().change_scene_to_packed(RoomGen.get_boss_room())
		RoomTypes.RoomTypes.HUB:
			get_tree().change_scene_to_packed(RoomGen.get_hub())

func activate():
	show()
	monitoring = true
