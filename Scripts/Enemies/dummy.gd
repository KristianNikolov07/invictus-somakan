extends Enemy


func _process(_delta: float) -> void:
	if hp <= 100:
		hp = max_hp
