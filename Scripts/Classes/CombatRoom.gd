extends Node2D
class_name CombatRoom

signal on_completion

@export var wave1_enemies : Array[PackedScene]
@export var wave1_quantity = 0.0
@export var can_wave1_enemies_move = true
@export var wave2_enemies : Array[PackedScene]
@export var wave2_quantity = 0.0
@export var can_wave2_enemies_move = true

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
	remaining_spawnpoints = $Spawnpoints/Wave1.get_children()
	var enemies_to_load = wave1_enemies
	for i in range(len(enemies_to_load)):
		current_enemies.append(enemies_to_load[i])
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
			if current_wave <= 2:
				spawn_current_wave()
			else:
				completed = true
				on_completion.emit()
				CurrentRunStats.current_level += 1
			
func spawn_current_wave():
	current_enemies.clear()
	var enemies_to_load
	if current_wave == 1:
		enemies_to_load = wave1_enemies
	else:
		enemies_to_load = wave2_enemies
	for i in range(len(enemies_to_load)):
		current_enemies.append(enemies_to_load[i])
	if current_wave == 1:
		current_enemy_count = wave1_quantity * len(remaining_spawnpoints)
	else:
		current_enemy_count = wave2_quantity * len(remaining_spawnpoints)

	for i in range(current_enemy_count):
		var rand = randi_range(0, len(remaining_spawnpoints) - 1)
		var current_spawnpoint = remaining_spawnpoints.pop_at(rand)
		var current_enemy = current_enemies[randi_range(0, len(current_enemies) - 1)].instantiate()
		print(current_enemy)
		current_enemy.position = current_spawnpoint.position
		if current_wave == 1 and !can_wave1_enemies_move:
			current_enemy.can_move = false
		if current_wave == 2 and !can_wave2_enemies_move:
			current_enemy.can_move = false
		add_child(current_enemy)
	
	remaining_spawnpoints = $Spawnpoints/Wave2.get_children()
	current_wave += 1

func generate_enemies():
	pass
	
func _on_spawn_delay_timer_timeout():
	print("spawning")
	spawn_current_wave()
