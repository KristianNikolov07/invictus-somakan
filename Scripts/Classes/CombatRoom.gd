extends Node2D
class_name CombatRoom

signal on_completion

var current_wave : int = 1
var remaining_spawnpoints : Array = []
var current_enemies : Array[PackedScene] = []
var spawn_delay_timer : Timer = Timer.new()
var completed = false
var current_enemy_count = 0
@export var wave1_quantity : float = 1
@export var wave2_quantity : float = 1
@export var wave_2_trigger : Area2D
@export var spawn_delay : float = 2.5

func _ready():
	current_wave = 1
	remaining_spawnpoints = $Spawnpoints/Wave1.get_children()
	spawn_delay_timer.wait_time = spawn_delay
	spawn_delay_timer.one_shot = true
	spawn_delay_timer.timeout.connect(_on_spawn_delay_timer_timeout)
	add_child(spawn_delay_timer)
	spawn_delay_timer.start()
	
	if wave_2_trigger != null:
		wave_2_trigger.monitoring = false
		wave_2_trigger.body_entered.connect(spawn_current_wave)
		print("Combat room is ready")
	
func _physics_process(_delta: float) -> void:
	if spawn_delay_timer.is_stopped() and not completed:
		var is_enemy_alive = false
		for node in get_children():
			if node.is_in_group("Enemies"):
				is_enemy_alive = true
		if not is_enemy_alive:
			if current_wave <= 2:
				if wave_2_trigger == null:
					spawn_delay_timer.start()
				else:
					wave_2_trigger.monitoring = true
			else:
				completed = true
				on_completion.emit()
			
func spawn_current_wave(body = null):
	current_enemies.clear()
	if current_wave == 1:
		current_enemy_count = wave1_quantity * len(remaining_spawnpoints)
	else:
		if wave_2_trigger != null:
			wave_2_trigger.queue_free()
		current_enemy_count = wave2_quantity * len(remaining_spawnpoints)

	for i in range(current_enemy_count):
		var rand = randi_range(0, len(remaining_spawnpoints) - 1)
		var current_spawnpoint = remaining_spawnpoints.pop_at(rand)
		var current_enemy = current_spawnpoint.enemy.instantiate()
		print(current_enemy)
		current_enemy.position = current_spawnpoint.position
		add_child(current_enemy)
	
	remaining_spawnpoints = $Spawnpoints/Wave2.get_children()
	current_wave += 1

func generate_enemies():
	pass
	
func _on_spawn_delay_timer_timeout():
	print("spawning")
	spawn_current_wave()
