extends StatusEffect

func start_effect():
	get_parent().damage_mult *= 0.7

func act():
	get_parent().status_damage(damage, damage_number_color)
	
func end_effect():
	get_parent().damage_mult /= 0.7
	super.end_effect()
