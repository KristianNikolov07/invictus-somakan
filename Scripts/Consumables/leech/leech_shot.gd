extends Area2D
var leech_effect_scene = preload("res://Scenes/Consumables/leech/leech_effect.tscn")
@export var speed = 500
var target: Vector2
var player

func _physics_process(delta: float) -> void:
	target.y += gravity / 5 * delta
	global_position = global_position.move_toward(target, delta * speed)


func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("Players"):
		if body.is_in_group("Enemies") and body.has_method("damage_amount"):
			var leech_effect = leech_effect_scene.instantiate()
			leech_effect.player = player
			body.add_child(leech_effect)
		queue_free()
