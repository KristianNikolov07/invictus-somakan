extends Area2D
class_name Hitbox

@export var damage = 15
@export var crit_chance = 0.1
@export var crit_mult = 2

func get_damage():
	return damage
	
func set_damage(new_damage):
	damage = new_damage

func get_crit_chance():
	return crit_chance

func set_crit_chance(new_crit_chance):
	crit_chance = new_crit_chance

func get_crit_mult():
	return crit_mult

func set_crit_mult(new_crit_mult):
	crit_mult = new_crit_mult
	
