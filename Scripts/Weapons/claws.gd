extends Weapon
var dir = 1


func hit(direction : int):
	if direction == -1:
		$AnimationPlayer.play("Left")
		dir = -1
	else:
		$AnimationPlayer.play("Right")
		dir = 1
		


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("damage") and body.is_in_group("Enemies"):
		body.damage($Hitbox, knockback_amount * dir)
