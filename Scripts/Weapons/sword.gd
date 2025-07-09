extends Weapon
var dir = 1
var is_down = false


func hit(direction : int):
	if !is_down:
		if direction == -1:
			$AnimationPlayer.play("LeftDown")
			dir = -1
		else:
			$AnimationPlayer.play("RightDown")
			dir = 1
		is_down = true
		$Cooldown.start()
	else:
		if direction == -1:
			$AnimationPlayer.play("LeftUp")
			dir = -1
		else:
			$AnimationPlayer.play("RightUp")
			dir = 1
		is_down = false


func _on_sword_body_entered(body: Node2D) -> void:
	if body.has_method("damage") and body.is_in_group("Enemies"):
		
		body.damage($Hitbox, knockback_amount * dir)

func _on_cooldown_timeout() -> void:
	is_down = false
