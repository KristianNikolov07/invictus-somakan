extends Weapon

const pepper := preload("res://Scenes/Projectiles/pepper.tscn")
@onready var player = get_node("../../")


func _physics_process(delta: float) -> void:
	$GunTexture.look_at(get_global_mouse_position())
	if abs(int($GunTexture.rotation_degrees) % 360) > 90 and abs(int($GunTexture.rotation_degrees) % 360) < 270:
		$GunTexture/Gun.flip_v = true
	else:
		$GunTexture/Gun.flip_v = false
	
	if player.direction < 0:
		$ChushkopekHolderRight.show()
		$ChushkopekHolderLeft.hide()
	else:
		$ChushkopekHolderRight.hide()
		$ChushkopekHolderLeft.show()

func hit(_direction):
	if $Heat.value >= 20:
		var cooking_phase
		if $Heat.value < 290:
			cooking_phase = 1
			$Heat.value -= 50
		elif $Heat.value >= 290 and $Heat.value < 540:
			cooking_phase = 2
			$Heat.value -= 75
		elif $Heat.value >= 540 and $Heat.value < 790:
			cooking_phase = 3
			$Heat.value -= 150
		else:
			$Heat.value -= 1000
			cooking_phase = 4
		
		var new_pepper: Projectile = pepper.instantiate()
		new_pepper.cooking_phase = cooking_phase
		new_pepper.global_position = $GunTexture/ShootPoint.global_position
		new_pepper.rotation = player.global_position.direction_to(get_global_mouse_position()).angle()
		new_pepper.shooter_vel = player.velocity
		$GunTexture/Gun.play("shoot")
		
		get_tree().current_scene.add_child(new_pepper)


func _on_refresh_bar_timeout() -> void:
	if get_tree().paused == false:
		$Heat.value += 1


func _on_gun_right_animation_finished() -> void:
	$GunTexture/Gun.play("default")
