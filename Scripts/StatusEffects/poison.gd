extends StatusEffect

func act():
	get_parent().status_damage(damage, damage_number_color)
	get_parent().damage_mult *= 0.7
	
func end_effect():
	get_parent().damage_mult /= 0.7
