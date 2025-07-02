extends Enemy

func _ready() -> void:
	set_is_moving(false)

func _process(delta: float) -> void:
	if hp <= 0:
		hp = 100
