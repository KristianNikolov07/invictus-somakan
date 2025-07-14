extends Enemy


func _process(_delta: float) -> void:
	if hp <= 100:
		hp = max_hp

func damage_anim():
	$Sprite.play("damage")


func _on_sprite_animation_finished() -> void:
	$Sprite.play("default")
