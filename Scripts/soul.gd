extends Area2D

var target_reached := false
var target: CharacterBody2D
var velocity: Vector2
var speed = 50


func _ready() -> void:
	velocity = Vector2(randf_range(-200, 200), randf_range(-200, 200))


func _physics_process(delta: float) -> void:
	if !$Travel.is_stopped():
		position += velocity * delta
		velocity = velocity.move_toward(Vector2.ZERO, delta*100)
	elif !target_reached:
		position = position.move_toward(target.global_position, delta*speed)
		speed = move_toward(speed, 900, 3)


func _on_body_entered(body: Node2D) -> void:
	if body == target:
		target_reached = true
		PlayerStats.souls += 1
		$CPUParticles2D.explosiveness = 1
		$CPUParticles2D.one_shot = true
		$AnimationPlayer.play("explode")
		$Sprite.hide()
		await $AnimationPlayer.animation_finished
		queue_free()
