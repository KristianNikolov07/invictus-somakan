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
		var aspect
		var equipped_aspects = get_equipped_aspects()
		if equipped_aspects[0] != null and equipped_aspects[1] != null:
			var synergetic_aspect_path = AspectSynergies.get_synergetic_aspect_path(equipped_aspects[0], equipped_aspects[1])
			aspect = load(synergetic_aspect_path)
		elif equipped_aspects[0] != null and equipped_aspects[1] == null:
			aspect = equipped_aspects[0]
		elif equipped_aspects[0] == null and equipped_aspects[1] != null:
			aspect = equipped_aspects[1]
		if aspect != null:
			aspect.apply_crit_stats($Hitbox)
		body.damage($Hitbox, knockback_amount * dir)
		if aspect != null:
			aspect.apply_effect(body)
			aspect.unapply_crit_stats($Hitbox)	
