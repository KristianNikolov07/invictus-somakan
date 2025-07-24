extends Weapon

const coin := preload("res://Scenes/Projectiles/coin.tscn")
const bullet := preload("res://Scenes/Projectiles/bullet.tscn")
@onready var player = get_node("../../")

func _physics_process(delta: float) -> void:
	$GunTexture.look_at(get_global_mouse_position())
	if abs(int($GunTexture.rotation_degrees) % 360) > 90 and abs(int($GunTexture.rotation_degrees) % 360) < 270:
		$GunTexture/Gun.flip_v = true
	else:
		$GunTexture/Gun.flip_v = false
		

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click") and $Coins.value >= 250:
		$Coin.play()
		player.get_node("PlayerSprite").play("cast")
		var new_coin = coin.instantiate()
		if player.direction < 0:
			$CoinLeft.show()
			$CoinLeft.play("default")
			new_coin.global_position = $CoinLeft.global_position
		else:
			$CoinRight.show()
			$CoinRight.play("default")
			new_coin.global_position = $CoinRight.global_position
		new_coin.dir = player.direction
		new_coin.shooter_vel = player.velocity
		get_tree().current_scene.add_child(new_coin)
		$Coins.value -= 250


func hit(_direction):
	if $ShotCool.is_stopped():
		$Shoot.pitch_scale = randf_range(0.9, 1.1)
		$Shoot.play()
		var new_bullet: Projectile = bullet.instantiate()
		new_bullet.damage = attack_damage
		new_bullet.global_position = $GunTexture/ShootPoint.global_position
		new_bullet.rotation = player.global_position.direction_to(get_global_mouse_position()).angle()
		new_bullet.shooter_vel = player.velocity
		new_bullet.set_aspect(get_aspect_to_apply())
		get_tree().current_scene.add_child(new_bullet)
		$ShotCool.start()


func _on_timer_timeout() -> void:
	$Coins.value += 3


func _on_coin_left_animation_finished() -> void:
	$CoinLeft.hide()


func _on_coin_right_animation_finished() -> void:
	$CoinRight.hide()
