extends Weapon
var arrow = preload("res://Scenes/Projectiles/arrow.tscn")
@export var arrow_damage = 10
@export var max_loaded_arrows = 4
@export var reload_time_per_arrow = 5
@onready var loaded_arrows = max_loaded_arrows

var can_be_shot = true


func hit(direction: int):
	if loaded_arrows > 0 and can_be_shot:
		var player = get_node("../../")
		var arrow: Projectile = arrow.instantiate()
		arrow.can_hit_enemies = true
		arrow.can_hit_players = false
		arrow.damage = arrow_damage
		arrow.global_position = global_position
		arrow.rotation = global_position.direction_to(get_global_mouse_position()).angle()
		arrow.shooter_vel = player.velocity
		get_tree().current_scene.add_child(arrow)
		loaded_arrows -= 1
		update_timer()
		$Cooldown.start()
		can_be_shot = false

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
