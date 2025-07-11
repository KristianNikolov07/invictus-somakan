extends Area2D
class_name Projectile


@export var speed = 400
@export var damage = 10
@export var knockback: float = 1
@export var can_be_parried := true
@export var can_hit_enemies := false
@export var can_hit_players := true
var times_parried = 0
var shooter_vel = 0

func _physics_process(delta: float) -> void:
	var direction  = Vector2.RIGHT.rotated(rotation)
	var forward_speed = shooter_vel.dot(direction)
	forward_speed = max(forward_speed, 0.0)
	global_position += (speed + forward_speed) * direction * delta

func calculate_direction(body):
	var knockback_dir = 1
	if body.global_position.x > global_position.x:
		knockback_dir = 1
	else:
		knockback_dir = -1
	return knockback_dir
