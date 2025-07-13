extends StatusEffect

func add_stack(amount:= 1):
	stacks += amount
	if stacks >= needed_stacks:
		stacks = needed_stacks
		
func end_effect():
	print("Ending bleed")
	get_parent().status_damage(damage * stacks, damage_number_color, crit_chance)
	super.end_effect()
	
