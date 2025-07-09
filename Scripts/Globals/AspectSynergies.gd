extends Node

var synergies = {
	"Fire": [
		["Poison", "res://Items/Aspects/ChemicalBurn.tres"], #more demig baybeee
		["Freeze", "res://Items/Aspects/Frostburn.tres"], #fire demig but with slow down
		["Critical Chance", "res://Items/Aspects/Inferno.tres"], #fire but with crits
		["Critical Damage", "res://Items/Aspects/Explosion.tres"] #kablooie
	],
	"Poison": [
		["Fire", "res://Items/Aspects/Chemical Burn.tres"],
		["Freeze", "res://Items/Aspects/Wither.tres"], #wither will slow down and make them deal less demig
		["Critical Chance", "res://Items/Aspects/Toxic.tres"], #faster ticking poison
		["Critical Damage", "res://Items/Aspects/InstantPoison.tres"] #instantly fills all charges for poison
	],
	"Freeze": [
		["Fire", "res://Items/Aspects/Frostburn.tres"],
		["Poison", "res://Items/Aspects/Wither.tres"],
		["Critical Chance", "res://Items/Aspects/Frostbite.tres"], #has a 50% chance to insta freeze
		["Critical Damage", "res://Items/Aspects/Blizzard.tres"] #increased damage on ice break
	],
	"Critical Chance": [
		["Fire", "res://Items/Aspects/Inferno.tres"],
		["Poison", "res://Items/Aspects/Toxic.tres"],
		["Freeze", "res://Items/Aspects/Frostbite.tres"],
		["Critical Damage", "res://Items/Aspects/Bleed.tres"] #stacks up until you crit, then a lot of damage gets unleashed
	],
	"Critical Damage": [
		["Fire", "res://Items/Aspects/Explosion.tres"],
		["Poison", "res://Items/Aspects/InstantPoison.tres"],
		["Freeze", "res://Items/Aspects/Blizzard.tres"],
		["Critical Chance", "res://Items/Aspects/Bleed.tres"]
	]
}

func get_synergetic_aspect_path(aspect1: AspectItem, aspect2: AspectItem):
	var table = synergies[aspect1.aspect_name]
	for entry in table:
		if entry[0] == aspect2.aspect_name:
			return entry[1]
	return null
		
