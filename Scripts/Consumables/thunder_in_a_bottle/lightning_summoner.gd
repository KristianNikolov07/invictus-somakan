extends Node
var target : Vector2
var lightning_scene = preload("res://Scenes/Consumables/thunder_in_a_bottle/lightning.tscn")

func _ready() -> void:
	_on_hit_interval_timeout()

func _on_hit_interval_timeout() -> void:
	var lightning = lightning_scene.instantiate()
	lightning.global_position = target
	add_child(lightning)


func _on_duration_timeout() -> void:
	queue_free()
