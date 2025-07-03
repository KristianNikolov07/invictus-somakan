extends Enemy


func _process(delta: float) -> void:
	if hp <= 100:
		hp = max_hp
