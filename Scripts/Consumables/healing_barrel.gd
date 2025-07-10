extends Consumable

@export var heal_amount = 30

func use():
	PlayerStats.get_player().heal(heal_amount)
