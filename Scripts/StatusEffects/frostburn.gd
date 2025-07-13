extends StatusEffect

func start_effect():
	get_parent().speed *= 0.5

func act():
	get_parent().status_damage(damage, damage_number_color)
	
func end_effect():
	get_parent().speed /= 0.5
	super.end_effect()
