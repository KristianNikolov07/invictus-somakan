extends Node

var combat_rooms: Array[PackedScene]
var puzzle_rooms: Array[PackedScene]
var current_room: int = 0

func _ready() -> void:
	fill_rooms(Stages.Stages.MEDIEVAL)


func fill_rooms(era: Stages.Stages) -> void:
	combat_rooms = []
	puzzle_rooms = []
	var stage: String
	current_room = 0
	
	match era:
		Stages.Stages.MEDIEVAL: stage = "Medieval"
		Stages.Stages.PRESENT: stage = "Present"
		Stages.Stages.FUTURE: stage = "Future"
	
	var path := "res://Scenes/Rooms/" + stage
	var variations := DirAccess.get_directories_at(path)
	var rand = randi_range(1, variations.size())
	path += "/Var" + str(rand)
	
	
	var combat_files = DirAccess.get_files_at(path + "/Combat")
	for file in combat_files:
		combat_rooms.append(load(path + "/Combat/" + file))
	
	var puzzle_files = DirAccess.get_files_at(path + "/Puzzles")
	for file in puzzle_files:
		puzzle_rooms.append(load(path + "/Puzzles/" + file))


func pull_combat_room() -> PackedScene:
	var rand = randi_range(0, combat_rooms.size())
	return combat_rooms.pop_at(rand)

func pull_puzzle_room() -> PackedScene:
	var rand = randi_range(0, puzzle_rooms.size())
	return puzzle_rooms.pop_at(rand)

func next_room() -> void:
	current_room += 1
	#if current_room > smth:
		#smth
