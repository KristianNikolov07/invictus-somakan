extends StatusEffect

var old_speed
var old_attack_damage
var old_coll_damage
var old_knockback_strength
var old_coll_knockback

func act():
	get_parent().status_damage(damage, damage_number_color)
	end_effect()

func start_effect():
	old_speed = get_parent().speed
	get_parent().speed = 0
	old_attack_damage = get_parent().attack_damage
	get_parent().attack_damage = 0
	old_coll_damage = get_parent().coll_damage
	get_parent().coll_damage = 0
	old_knockback_strength = get_parent().knockback_strength
	get_parent().knockback_strength = 0
	old_coll_knockback = get_parent().coll_knockback
	get_parent().coll_knockback = 0

func on_hit(hitbox: Hitbox, damage: int, knockback):
	end_effect()
	
func end_effect():
	get_parent().speed = old_speed
	get_parent().attack_damage = old_attack_damage
	get_parent().coll_damage = old_coll_damage
	get_parent().knockback_strength = old_knockback_strength
	get_parent().coll_knockback = old_coll_knockback
	super.end_effect()
