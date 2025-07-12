extends Consumable

@export var heal_amount = 20

func use(_player_path: String):
	PlayerStats.get_player().heal(heal_amount)
