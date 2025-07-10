extends Consumable

@export var heal_amount = 20

func use():
	PlayerStats.get_player().heal(heal_amount)
