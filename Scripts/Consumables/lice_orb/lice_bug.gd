extends Area2D
@export var speed = 200
var target: Enemy
@export var damage = 10

func _ready() -> void:
	_on_retarget_timeout()

func _physics_process(delta: float) -> void:
	if target == null:
		_on_retarget_timeout()
	else:
		global_position = global_position.move_toward(target.global_position, delta * speed)


func _on_retarget_timeout() -> void:
	var _target = get_tree().get_first_node_in_group("Enemies")
	if _target == null:
		queue_free()
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if _target.global_position.distance_to(global_position) > enemy.global_position.distance_to(global_position):
			_target = enemy
	
	target = _target


func _on_destroy_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("Players"):
		if body.has_method("damage_amount"):
			body.damage_amount(damage, 0)


func _on_damage_timer_timeout() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("Enemies"):
			body.damage_amount(damage, 0)
