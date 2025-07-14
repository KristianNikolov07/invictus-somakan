extends Node2D

const pepper := preload("res://Scenes/Projectiles/pepper.tscn")
@onready var player = get_node("../../")


func _physics_process(delta: float) -> void:
	if player.direction < 0:
		$ChushkopekHolderRight.hide()
		$ChushkopekHolderLeft.show()
		
		$GunRight.hide()
		$GunLeft.show()
	else:
		$ChushkopekHolderRight.show()
		$ChushkopekHolderLeft.hide()
		
		$GunRight.hide()
		$GunLeft.show()

func hit(_direction):
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
	new_pepper.global_position = player.global_position
	new_pepper.rotation = player.global_position.direction_to(get_global_mouse_position()).angle()
	new_pepper.shooter_vel = player.velocity
	if _direction < 0:
		$GunLeft.play("shoot")
	else:
		$GunRight.play("shoot")
	
	get_tree().current_scene.add_child(new_pepper)


func _on_refresh_bar_timeout() -> void:
	$Heat.value += 1


func _on_gun_right_animation_finished() -> void:
	$GunRight.play("default")


func _on_gun_left_animation_finished() -> void:
	$GunLeft.play("default")
