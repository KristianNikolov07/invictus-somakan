extends CharacterBody2D

const accel = 150
const max_falling_speed = 1000
const max_walking_speed = 400
const jump_force = 900
const gravity = 40
const jump_easing = -200
const dash_speed = 3 * max_walking_speed
var jumps_remaining = 1
var max_jumps = 1
var speed_mult = 1
var direction = 1
var max_hp = 50
var hp = 50

func _ready() -> void:
	$Parry.start()
	$Parry.stop()

func _physics_process(delta: float) -> void:
	if $DashTimer.is_stopped():
		process_movement()
	if is_on_floor():
		jumps_remaining = max_jumps
	move_and_slide()
	$ParryTimerTestLabel.text = str($Parry.time_left)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump") and jumps_remaining > 0:
		velocity.y = 0
		jumps_remaining -= 1
		velocity += Vector2(0, -jump_force)
	elif event.is_action_released("Jump"):
		velocity.y = max(velocity.y, jump_easing)
	elif event.is_action_pressed("Left"):
		$ParryArea.rotation_degrees = 180
		direction = -1
	elif event.is_action_pressed("Right"):
		$ParryArea.rotation_degrees = 0
		direction = 1
	elif event.is_action_pressed("Dash") and $DashCooldown.is_stopped():
		$DashTimer.start()
		$DashCooldown.start()
		velocity = Vector2(dash_speed * direction, 0)
	elif event.is_action_pressed("Parry"):
		$ParryArea.set_collision_mask_value(1, true)
		$ParryArea.set_collision_mask_value(3, true)
		$Parry.start()

func check_parry(area):
	if area.has_method("parry") and !$Parry.is_stopped() and area.attacking:
		if(area.global_position.x < global_position.x and direction == -1 and area.velocity.x >= 0) or (area.global_position.x > global_position.x and direction == 1 and area.velocity.x <= 0):
			return $Parry.time_left
	return 0

func get_parry_time():
	return $Parry.wait_time

func stop_parry():
	if !$Parry.is_stopped():
		$Parry.stop()
		_on_parry_timeout()
		$Invincibility.start()

func process_movement():
	if $Parry.is_stopped():
		if Input.is_action_pressed("Right"):
			velocity.x = move_toward(velocity.x, max_walking_speed * speed_mult, accel)
		elif Input.is_action_pressed("Left"):
			velocity.x = move_toward(velocity.x, -max_walking_speed * speed_mult, accel)
		else:
			velocity.x = move_toward(velocity.x, 0, accel)
		
		if Input.is_action_pressed("Dash") and is_on_floor():
			speed_mult = 1.6
		elif not Input.is_action_pressed("Dash"):
			speed_mult = 1
		
		velocity.y = move_toward(velocity.y, max_falling_speed, gravity)
	else:
		velocity = Vector2(0, 0)


func damage(amount, knockback) -> void:
	set_collision_layer_value(1, false)
	$Invincibility.start()
	velocity.x = 1600 * knockback
	velocity.y = -500 * abs(knockback)
	hp -= amount
	$Parry.stop()
	#if hp <= 0:
		#get_tree().quit()
	print(amount)

func _on_invincibility_timeout() -> void:
	set_collision_layer_value(1, true)


func _on_parry_area_area_entered(area: Area2D) -> void:
	pass
	#if area.get_parent().has_method("parry") and check_parry(area) > 0:
		#area.get_parent().parry()
		#$Parry.call_deferred("stop")
		#$Invincibility.start()
		#call_deferred("_on_parry_timeout")
		#$Hitstop.start()
		#set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

func _on_parry_timeout() -> void:
	$ParryArea.set_collision_mask_value(1, false)
	$ParryArea.set_collision_mask_value(3, false)

func _on_hitstop_timeout() -> void:
	pass
	#set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
