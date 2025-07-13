extends Projectile
var lightning_summoner_scene = preload("res://Scenes/Consumables/thunder_in_a_bottle/lightning_summoner.tscn")

func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("Players"):
		var lightning_summoner = lightning_summoner_scene.instantiate()
		lightning_summoner.target = global_position
		get_parent().add_child(lightning_summoner, true)
		queue_free()
