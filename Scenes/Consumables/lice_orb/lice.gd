extends Projectile
var lice_bug_scene = preload("res://Scenes/Consumables/lice_orb/lice_bug.tscn")

func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("Players"):
		if body.has_method("damage_amount"):
			body.damage_amount(damage, knockback)
		var lice_bug = lice_bug_scene.instantiate()
		lice_bug.global_position = global_position
		get_parent().add_child(lice_bug)
		queue_free()
