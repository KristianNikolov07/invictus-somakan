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
	if PlayerStats.weapon1 != null and PlayerStats.weapon1.item_name == weapon_name:
		return PlayerStats.weapon1_aspects
	elif PlayerStats.weapon2 != null and PlayerStats.weapon2.item_name == weapon_name:
		return PlayerStats.weapon2_aspects
	else:
		return null
	
func get_aspect_to_apply():
	var aspect = null
	var equipped_aspects = get_equipped_aspects()
	if equipped_aspects != null:
		if equipped_aspects[0] != null and equipped_aspects[1] != null:
			var synergetic_aspect_path = AspectSynergies.get_synergetic_aspect_path(equipped_aspects[0], equipped_aspects[1])
			aspect = load(synergetic_aspect_path)
		elif equipped_aspects[0] != null and equipped_aspects[1] == null:
			aspect = equipped_aspects[0]
		elif equipped_aspects[0] == null and equipped_aspects[1] != null:
			aspect = equipped_aspects[1]
		return aspect
