extends CharacterBody2D

var accel = 150
var max_falling_speed = 1000
var max_walking_speed = 400
var jump_force = 800
var jumps_remaining = 1
var max_jumps = 1
var gravity = 40
var jump_easing = -250

func _physics_process(delta: float) -> void:
	process_movement()
	if is_on_floor():
		jumps_remaining = max_jumps

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump") and jumps_remaining > 0:
		velocity.y = 0
		jumps_remaining -= 1
		velocity += Vector2(0, -jump_force)
	elif event.is_action_released("Jump"):
		velocity.y = max(velocity.y, jump_easing)

func process_movement():
	if Input.is_action_pressed("Right"):
		velocity.x = move_toward(velocity.x, max_walking_speed, accel)
	elif Input.is_action_pressed("Left"):
		velocity.x = move_toward(velocity.x, -max_walking_speed, accel)
	else:
		velocity.x = move_toward(velocity.x, 0, accel)
	velocity.y = move_toward(velocity.y, max_falling_speed, gravity)
	move_and_slide()
