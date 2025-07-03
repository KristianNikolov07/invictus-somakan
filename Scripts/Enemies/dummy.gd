extends Enemy


func _process(delta: float) -> void:
	if hp <= 0:
		hp = max_hp
