extends Node2D
class_name Weapon

@export var attack_damage = 10
@export var crit_chance = 0.1
@export var crit_mult = 2
@export var knockback_amount = 1

func hit(direction: int):
	pass

func _ready() -> void:
	if $Hitbox != null:
		$Hitbox.set_damage(attack_damage)
		$Hitbox.set_crit_chance(crit_chance)
		$Hitbox.set_crit_mult(crit_mult)
