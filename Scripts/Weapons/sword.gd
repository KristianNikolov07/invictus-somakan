extends Node
@export var attack_damage = 10
@export var knockback_amount = 1

func hit(direction : int):
	if direction == -1:
		$Weapons/Sword/AnimationPlayer.play("Left")
	else:
		$Weapons/Sword/AnimationPlayer.play("Right")


func _on_sword_body_entered(body: Node2D) -> void:
	if body.has_method("damage"):
		body.damage(attack_damage,knockback_amount)
