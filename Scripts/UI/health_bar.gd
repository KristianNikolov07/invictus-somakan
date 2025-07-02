extends ProgressBar

@onready var body = get_node("../")

func _process(delta: float) -> void:
	value = (100 * body.hp) / body.max_hp 
