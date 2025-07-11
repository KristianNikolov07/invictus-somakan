extends Node

var damage = 30
var heal_percentage : float = 20
var player: CharacterBody2D


func _on_effect_duration_timeout() -> void:
	queue_free()


func _on_damage_timer_timeout() -> void:
	get_parent().damage_amount(damage, 0)
	player.heal(heal_percentage / 100 * damage)
