extends Area2D

@export_subgroup("Stage Transitions")
@export var is_stage_transition = false
@export var next_stage : Stages.Stages

func interact():
	if is_stage_transition:
		RoomGen.fill_rooms(next_stage)
	# TODO: Add the teleportation here
