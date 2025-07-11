extends ProgressBar

@onready var body = get_node("../")

func _process(delta: float) -> void:
	value = (100 * body.get_hp()) / body.get_max_hp()
