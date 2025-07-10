extends Area2D

var target : CharacterBody2D
@export var speed = 50
@export var heal_amount = 5

func _ready() -> void:
	retarget()

func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, delta * speed)

func retarget():
	var _target = get_tree().get_first_node_in_group("Players")
	
	for player in get_tree().get_nodes_in_group("Players"):
		if _target.global_position.distance_to(global_position) > player.global_position.distance_to(global_position):
			_target = player
	
	target = _target


func _on_healing_cooldown_timeout() -> void:
	for body in get_overlapping_bodies():
		print(body)
		if body.is_in_group("Players"):
			body.heal(heal_amount)


func _on_delete_timer_timeout() -> void:
	queue_free()
