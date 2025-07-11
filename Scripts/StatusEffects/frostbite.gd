extends StatusEffect

var old_attack_damage
var old_coll_damage
var old_knockback_strength
var old_coll_knockback

func add_stack(amount:= 1):
	if randi_range(0, 2) == 2:
		stacks = needed_stacks
	else:
		stacks += amount
	if stacks >= needed_stacks:
		stacks = 0
		if remaining_timer.is_stopped():
			start_effect()
		if not remaining_timer.is_stopped():
			remaining_timer.stop()
		remaining_timer.start()
		if not tick_timer.is_stopped():
			tick_timer.stop()
		tick_timer.start()

func act():
	get_parent().status_damage(damage, damage_number_color)
	end_effect()

func start_effect():
	get_parent().set_is_moving(false)
	old_attack_damage = get_parent().attack_damage
	get_parent().attack_damage = 0
	old_coll_damage = get_parent().coll_damage
	get_parent().coll_damage = 0
	old_knockback_strength = get_parent().knockback_strength
	get_parent().knockback_strength = 0
	old_coll_knockback = get_parent().coll_knockback
	get_parent().coll_knockback = 0
	
func end_effect():
	get_parent().set_is_moving(true)
	get_parent().attack_damage = old_attack_damage
	get_parent().coll_damage = old_coll_damage
	get_parent().knockback_strength = old_knockback_strength
	get_parent().coll_knockback = old_coll_knockback
	super.end_effect()
