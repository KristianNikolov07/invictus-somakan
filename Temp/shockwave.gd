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
