extends CharacterBody2D
class_name Enemy

@export var speed = 150
@export var coll_damage = 5
@export var attack_damage = 15
@export var knockback_strength = 1.5
@export var hp = 20
@export var coll_knockback = 1
@export var max_hp = 20
const JUMP_VELOCITY = -400.0
const FOLLOW_DEADZONE = 1
var is_moving = true


var target : CharacterBody2D
var timer = Timer.new()

func _ready() -> void:
	timer.wait_time = 1
	timer.timeout.connect(set_new_target)
	timer.autostart = true
	add_child(timer)
	set_new_target()

func damage(amount, knockback):
	pass

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
	if target.global_position.x < global_position.x:
		direction = -1
	else:
		direction = 1
	
	if direction and (target.global_position - global_position).abs().x > FOLLOW_DEADZONE and is_moving:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
