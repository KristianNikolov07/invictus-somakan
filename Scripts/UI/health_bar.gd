extends ProgressBar

@onready var body = get_node("../")

func _process(_delta: float) -> void:
	if body.get_hp() != null and body.get_max_hp() != null:
		value = (100 * body.get_hp()) / body.get_max_hp()
