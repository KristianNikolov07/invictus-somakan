extends Area2D

var damage = 15
var max_fall = 1250
var speed := Vector2.ZERO


func _ready() -> void:
	rotation_degrees = randf_range(0, 360)
	speed.x = randf_range(-300, 300)
	speed.y = randf_range(-500, -400)

func _physics_process(delta: float) -> void:
	global_position += speed * delta
	speed.x = move_toward(speed.x, 0, delta*75)
	speed.y = move_toward(speed.y, max_fall, delta*400)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Enemies"):
		var ex = Utils.summon_explosion(global_position, 3, 15, 1.2, 1, true, true)
		get_tree().current_scene.call_deferred("add_child", ex)
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Projectile:
		var ex = Utils.summon_explosion(global_position, 3, 15, 1.2, 1, true, true)
		get_tree().current_scene.call_deferred("add_child", ex)
		area.queue_free()
		queue_free()
