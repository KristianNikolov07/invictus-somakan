extends CharacterBody2D

const accel = 150
const max_falling_speed = 1000
const max_walking_speed = 400
const jump_force = 900
const gravity = 40
const jump_easing = -250
const dash_speed = 3 * max_walking_speed
var jumps_remaining = 1
var max_jumps = 1
var speed_mult = 1
var direction = 1

#Change this for other weapons
var selected_weapon = Weapons.Weapons.SWORD

func _physics_process(delta: float) -> void:
	if $DashTimer.is_stopped():
		process_movement()
	if is_on_floor():
		jumps_remaining = max_jumps
	move_and_slide()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump") and jumps_remaining > 0:
		velocity.y = 0
		jumps_remaining -= 1
		velocity += Vector2(0, -jump_force)
	elif event.is_action_released("Jump"):
		velocity.y = max(velocity.y, jump_easing)
	elif event.is_action_pressed("Left"):
		direction = -1
	elif event.is_action_pressed("Right"):
		direction = 1
	elif event.is_action_pressed("Dash") and $DashCooldown.is_stopped():
		$DashTimer.start()
		$DashCooldown.start()
		velocity = Vector2(dash_speed * direction, 0)
	elif event.is_action_pressed("Attack"):
		attack()

func process_movement():
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
	

func attack():
	if selected_weapon == Weapons.Weapons.SWORD:
		$Weapons/Sword.hit(direction)
