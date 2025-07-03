extends Node

var combat_rooms: Array
var puzzle_rooms: Array


func fill_rooms(era: Stages.Stages):
	var stage: String
	
	match era:
		Stages.Stages.MEDIEVAL: stage = "Medieval"
		Stages.Stages.PRESENT: stage = "Present"
		Stages.Stages.FUTURE: stage = "Future"
	
	DirAccess.get_directories_at("res://Scenes/Rooms")
