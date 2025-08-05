extends Weapon
var dir = 1

func _ready():
	if get_node_or_null("LeftHitbox") != null:
		$LeftHitbox.set_damage(attack_damage)
		$LeftHitbox.set_crit_chance(crit_chance)
		$LeftHitbox.set_crit_mult(crit_mult)
	if get_node_or_null("RightHitbox") != null:
		$RightHitbox.set_damage(attack_damage)
		$RightHitbox.set_crit_chance(crit_chance)
		$RightHitbox.set_crit_mult(crit_mult)

func hit(direction : int):
	if direction == -1:
		$LeftSprite.show()
		$LeftSprite.play("default")
		$LeftHitbox.monitoring = true
		dir = -1
	else:
		$RightSprite.show()
		$RightSprite.play("default")
		$RightHitbox.monitoring = true
		dir = 1

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("damage") and body.is_in_group("Enemies"):
		var aspect = get_aspect_to_apply()
		var equipped_aspects = get_equipped_aspects()
		if equipped_aspects[0] != null and equipped_aspects[1] != null:
			var synergetic_aspect_path = AspectSynergies.get_synergetic_aspect_path(equipped_aspects[0], equipped_aspects[1])
			aspect = load(synergetic_aspect_path)
		elif equipped_aspects[0] != null and equipped_aspects[1] == null:
			aspect = equipped_aspects[0]
		elif equipped_aspects[0] == null and equipped_aspects[1] != null:
			aspect = equipped_aspects[1]
		if aspect != null:
			aspect.apply_crit_stats($RightHitbox)
		body.damage($RightHitbox, knockback_amount * dir)
		if aspect != null:
			aspect.apply_effect(body)
			aspect.unapply_crit_stats($RightHitbox)


func _on_right_sprite_animation_finished() -> void:
	$RightSprite.hide()
	$RightHitbox.monitoring = false

func _on_left_sprite_animation_finished() -> void:
	$LeftSprite.hide()
	$LeftHitbox.monitoring = false
