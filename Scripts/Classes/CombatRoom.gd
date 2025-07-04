extends Node2D
class_name CombatRoom

signal on_completion

var current_level_data : Dictionary = {}
var current_wave : int = 1
var current_enemy_count : int = 0
var remaining_spawnpoints : Array = []
var current_enemies : Array[PackedScene] = []
var spawn_delay_timer : Timer = Timer.new()
var completed = false
@export var spawn_delay : float = 2.5

func _ready():
	current_wave = 1
	current_enemy_count = 0
	var stage = CurrentRunStats.current_stage
	var stage_name
	match stage:
		Stages.Stages.MEDIEVAL: stage_name = 'Medieval'
		Stages.Stages.PRESENT: stage_name = 'Present'
		Stages.Stages.FUTURE: stage_name = 'Future'
		
	current_level_data = RoomData.RoomData[stage_name + "Var" + str(CurrentRunStats.current_level) + "Data"]["Level" + str(CurrentRunStats.current_level)]
	remaining_spawnpoints = $Spawnpoints.get_children()
	var enemies_to_load = current_level_data["Wave" + str(current_wave)]["Enemies"]
	for i in range(len(enemies_to_load)):
		current_enemies.append(load("res://Scenes/Enemies/" + enemies_to_load[i] + ".tscn"))
	spawn_delay_timer.wait_time = spawn_delay
	spawn_delay_timer.one_shot = true
	spawn_delay_timer.timeout.connect(_on_spawn_delay_timer_timeout)
	add_child(spawn_delay_timer)
	spawn_delay_timer.start()
	
	print("Combat room is ready")
	
func _physics_process(_delta: float) -> void:
	if spawn_delay_timer.is_stopped() and not completed:
		var is_enemy_alive = false
		for node in get_children():
			if node.is_in_group("Enemies"):
				is_enemy_alive = true
		if not is_enemy_alive:
			if current_wave <= len(current_level_data):
				spawn_current_wave()
			else:
				completed = true
				on_completion.emit()
				CurrentRunStats.current_level += 1
			
func spawn_current_wave():
	current_enemy_count = int(current_level_data["Wave" + str(current_wave)]["SpawnQuantity"] * len(remaining_spawnpoints))
	for i in range(current_enemy_count):
		var rand = randi_range(0, len(remaining_spawnpoints) - 1)
		var current_spawnpoint = remaining_spawnpoints.pop_at(rand)
		var current_enemy = current_enemies[randi_range(0, len(current_enemies) - 1)].instantiate()
		current_enemy.position = current_spawnpoint.position
		add_child(current_enemy)
	
	remaining_spawnpoints = $Spawnpoints.get_children()
	current_wave += 1

func generate_enemies():
	pass
	
func _on_spawn_delay_timer_timeout():
	print("spawning")
	spawn_current_wave()
