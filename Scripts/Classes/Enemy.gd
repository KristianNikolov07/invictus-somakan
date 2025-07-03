extends CharacterBody2D
class_name Enemy

@export var speed = 150
@export var coll_damage = 5
@export var attack_damage = 15
@export var knockback_strength = 1.5
@export var hp = 20
@export var coll_knockback = 1
@export var max_hp = 20
@export var parry_damage = 1
@export var parry_knockback_mult = 1
@export var invincibility_length = 0.5
@export var can_be_knockedback = true
const JUMP_VELOCITY = -400.0
const FOLLOW_DEADZONE = 1
@export var is_moving = true
var attacking = false

var target : CharacterBody2D
var retarget_timer = Timer.new()
var invincibility_timer = Timer.new()

func _ready() -> void:
	retarget_timer.wait_time = 1
	retarget_timer.timeout.connect(set_new_target)
	retarget_timer.autostart = true
	add_child(retarget_timer)
	set_new_target()
	
	invincibility_timer.wait_time = invincibility_length
	invincibility_timer.timeout.connect(_on_invincibility_timer_timeout)
	invincibility_timer.autostart = true
	add_child(invincibility_timer)

func parry():
	damage(parry_damage, parry_knockback_mult)

func damage(amount, knockback) -> void:
	set_collision_layer_value(1, false)
	invincibility_timer.start()
	if !can_be_knockedback:
		knockback = 0
	velocity.x = 1600 * knockback
	velocity.y = -500 * abs(knockback)
	hp -= amount
	if hp <= 0:
		queue_free()
	print(amount)

func set_is_moving(_is_moving : bool):
	is_moving = _is_moving

func set_new_target():
	var closest_player : CharacterBody2D
	for player in get_tree().get_nodes_in_group("Players"):
		if closest_player == null:
			closest_player = player
		elif closest_player.global_position.abs().x - global_position.abs().x > player.global_position.abs().x - global_position.abs().x:
			closest_player = player
	target = closest_player

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	var direction
	if target != null:
		if target.global_position.x < global_position.x:
			direction = -1
		else:
			direction = 1
		
		if direction and (target.global_position - global_position).abs().x > FOLLOW_DEADZONE and is_moving:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()


func _on_invincibility_timer_timeout():
	set_collision_layer_value(1, true)
