extends Area2D

var size: float
var damage: int
var knockback: float
var speed_scale: float
var can_hit_enemies := true
var can_hit_players := false


func _ready() -> void:
	$AnimationPlayer.play("explode")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players") and can_hit_players:
		body.damage_amount(damage, knockback*calculate_direction(body))
	elif body.is_in_group("Enemies") and can_hit_enemies:
		body.damage_amount(damage, knockback*calculate_direction(body))

func _on_area_entered(area: Area2D) -> void:
	if "speed" in area:
		area.speed *= calculate_direction(area)*2


func calculate_direction(body):
	var knockback_dir = 1
	if body.global_position.x > global_position.x:
		knockback_dir = 1
	else:
		knockback_dir = -1
	return knockback_dir


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explode":
		await $AudioStreamPlayer2D.finished
		queue_free()
