extends StatusEffect

func act():
	get_parent().status_damage(damage, damage_number_color)
