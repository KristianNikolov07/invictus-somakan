extends TextureProgressBar

@onready var body = get_node("../")

func _process(_delta: float) -> void:
	value = (100 * body.get_hp()) / body.get_max_hp()
