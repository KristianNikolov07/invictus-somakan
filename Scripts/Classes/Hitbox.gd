extends Area2D
class_name Hitbox

@export var damage = 15

func get_damage():
	return damage
	
func set_damage(new_damage):
	damage = new_damage
