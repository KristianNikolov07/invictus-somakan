extends Weapon

const coin := preload("res://Scenes/Projectiles/coin.tscn")
const bullet := preload("res://Scenes/Projectiles/bullet.tscn")
@onready var player = get_node("../../")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click") and $Coins.value >= 250:
		$Coin.pitch_scale = randf_range(0.9, 1.1)
		$Coin.play()
		var new_coin = coin.instantiate()
		new_coin.dir = player.direction
		new_coin.shooter_vel = player.velocity
		new_coin.global_position = player.global_position
		get_tree().current_scene.add_child(new_coin)
		$Coins.value -= 250


func hit(_direction):
	if $ShotCool.is_stopped():
		$Shoot.pitch_scale = randf_range(0.9, 1.1)
		$Shoot.play()
		var new_bullet: Projectile = bullet.instantiate()
		new_bullet.damage = attack_damage
		new_bullet.global_position = player.global_position
		new_bullet.rotation = player.global_position.direction_to(get_global_mouse_position()).angle()
		new_bullet.shooter_vel = player.velocity
		get_tree().current_scene.add_child(new_bullet)
		$ShotCool.start()


func _on_timer_timeout() -> void:
	$Coins.value += 3
