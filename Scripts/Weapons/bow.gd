extends Weapon
var arrow = preload("res://Scenes/Projectiles/arrow.tscn")
@export var arrow_damage = 10
@export var max_loaded_arrows = 4
@export var reload_time_per_arrow = 5
@onready var loaded_arrows = max_loaded_arrows

var can_be_shot = true

func _physics_process(delta: float) -> void:
	$Texture.look_at(get_global_mouse_position())

func hit(_direction: int):
	if loaded_arrows > 0 and can_be_shot:
		$Texture/AnimatedSprite2D.play("Shoot")
		var player = get_node("../../")
		var new_arrow: Projectile = arrow.instantiate()
		new_arrow.can_hit_enemies = true
		new_arrow.can_hit_players = false
		new_arrow.damage = arrow_damage
		new_arrow.global_position = global_position
		new_arrow.rotation = global_position.direction_to(get_global_mouse_position()).angle()
		new_arrow.shooter_vel = player.velocity
		new_arrow.set_aspect(get_aspect_to_apply())
		get_tree().current_scene.add_child(new_arrow)
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


func _on_animated_sprite_2d_animation_finished() -> void:
	$Texture/AnimatedSprite2D.play("default")
