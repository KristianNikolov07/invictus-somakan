extends Node
@export var attack_damage = 10
@export var knockback_amount = 1
var dir = 1

func hit(direction : int):
	if direction == -1:
		$AnimationPlayer.play("Left")
		dir = -1
	else:
		$AnimationPlayer.play("Right")
		dir = 1


func _on_sword_body_entered(body: Node2D) -> void:
	print(body)
	if body.has_method("damage") and body.is_in_group("Enemies"):
		body.damage(attack_damage, knockback_amount * dir)
