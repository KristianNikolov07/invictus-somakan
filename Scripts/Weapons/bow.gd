extends Weapon

var arrow = preload("res://Scenes/Projectiles/arrow.tscn")
@export var arrow_damage = 10
@export var max_loaded_arrows = 4
@export var reload_time_per_arrow = 5
@onready var loaded_arrows = max_loaded_arrows

var can_be_shot = true

func hit(_direction: int):
	if loaded_arrows > 0 and can_be_shot:
		var player = get_node("../../")
		var aim_angle = global_position.direction_to(get_global_mouse_position()).angle()
		var pos = player.global_position
		var vel = player.velocity

		if PlayerStats.is_multiplayer:
			rpc_id(1, "server_shoot_arrow", pos, aim_angle, vel)
		else:
			shoot_arrow(pos, aim_angle, vel)

		loaded_arrows -= 1
		update_timer()
		$Cooldown.start()
		can_be_shot = false

@rpc("authority", "call_local", "reliable")
func server_shoot_arrow(position: Vector2, rotation: float, velocity: Vector2):
	shoot_arrow.rpc(position, rotation, velocity)

@rpc("authority", "call_local", "reliable")
func shoot_arrow(position: Vector2, rotation: float, velocity: Vector2):
	var new_arrow: Projectile = arrow.instantiate()
	new_arrow.can_hit_enemies = true
	new_arrow.can_hit_players = false
	new_arrow.damage = arrow_damage
	new_arrow.global_position = position
	new_arrow.rotation = rotation
	new_arrow.shooter_vel = velocity
	get_tree().current_scene.add_child(new_arrow, true)

func update_timer():
	if $ReloadTimer.is_stopped():
		$ReloadTimer.wait_time = reload_time_per_arrow
		$ReloadTimer.start()
	else:
		$ReloadTimer.wait_time = snappedf($ReloadTimer.time_left + reload_time_per_arrow, 0.01)
		$ReloadTimer.start()
	$ProgressBar.max_value = snappedf($ReloadTimer.wait_time, 0.01)

func _on_reload_timer_timeout() -> void:
	loaded_arrows = max_loaded_arrows

func _on_cooldown_timeout() -> void:
	can_be_shot = true

func _on_refresh_progress_timeout() -> void:
	$ProgressBar.value = $ReloadTimer.wait_time - $ReloadTimer.time_left
