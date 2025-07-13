extends Node2D
class_name Weapon

var weapon: WeaponItem
var weapon_name: String
@export var attack_damage = 10
@export var crit_chance = 0.1
@export var crit_mult = 2
@export var knockback_amount = 1

func hit(_direction: int):
	pass

func _ready() -> void:
	if get_node_or_null("Hitbox") != null:
		$Hitbox.set_damage(attack_damage)
		$Hitbox.set_crit_chance(crit_chance)
		$Hitbox.set_crit_mult(crit_mult)

func get_equipped_aspects():
	if PlayerStats.weapon1.item_name == weapon_name:
		return PlayerStats.weapon1_aspects
	else:
		return PlayerStats.weapon2_aspects
	
