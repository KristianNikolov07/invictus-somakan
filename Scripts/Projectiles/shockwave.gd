extends Area2D

var max_speed = 2000
var damage = 10
var speed = 250
var dir = 1


func _ready() -> void:
	$CPUParticles2D.emitting = true


func _physics_process(delta: float) -> void:
	position.x += speed*dir*delta
	speed = min(speed+5, max_speed)


func _on_death_time_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		var knockback_dir = calculate_direction(body)
		body.damage_amount.rpc(damage, 1 * knockback_dir)

func calculate_direction(body):
	var knockback_dir = 1
	if body.global_position.x > global_position.x:
		knockback_dir = 1
	else:
		knockback_dir = -1
	return knockback_dir
