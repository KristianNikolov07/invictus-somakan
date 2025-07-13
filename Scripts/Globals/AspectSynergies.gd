extends Node

var synergies = {
	"Fire": [
		["Poison", "res://Items/Aspects/Synergetic/ChemicalBurn.tres"], #more demig baybeee
		["Freeze", "res://Items/Aspects/Synergetic/Frostburn.tres"], #fire demig but with slow down
		["Critical Chance", "res://Items/Aspects/Synergetic/Inferno.tres"], #fire but with crits
		["Critical Damage", "res://Items/Aspects/Synergetic/Explosion.tres"] #kablooie
	],
	"Poison": [
		["Fire", "res://Items/Aspects/Synergetic/ChemicalBurn.tres"],
		["Freeze", "res://Items/Aspects/Synergetic/Wither.tres"], #wither will slow down and make them deal less demig
		["Critical Chance", "res://Items/Aspects/Synergetic/Toxic.tres"], #faster ticking poison
		["Critical Damage", "res://Items/Aspects/Synergetic/InstantPoison.tres"] #instantly fills all charges for poison
	],
	"Freeze": [
		["Fire", "res://Items/Aspects/Synergetic/Frostburn.tres"],
		["Poison", "res://Items/Aspects/Synergetic/Wither.tres"],
		["Critical Chance", "res://Items/Aspects/Synergetic/Frostbite.tres"], #has a 50% chance to insta freeze
		["Critical Damage", "res://Items/Aspects/Synergetic/Blizzard.tres"] #increased damage on ice break
	],
	"Critical Chance": [
		["Fire", "res://Items/Aspects/Synergetic/Inferno.tres"],
		["Poison", "res://Items/Aspects/Synergetic/Toxic.tres"],
		["Freeze", "res://Items/Aspects/Synergetic/Frostbite.tres"],
		["Critical Damage", "res://Items/Aspects/Synergetic/Bleed.tres"] #stacks up until you crit, then a lot of damage gets unleashed
	],
	"Critical Damage": [
		["Fire", "res://Items/Aspects/Synergetic/Explosion.tres"],
		["Poison", "res://Items/Aspects/Synergetic/InstantPoison.tres"],
		["Freeze", "res://Items/Aspects/Synergetic/Blizzard.tres"],
		["Critical Chance", "res://Items/Aspects/Synergetic/Bleed.tres"]
	]
}

func get_synergetic_aspect_path(aspect1: AspectItem, aspect2: AspectItem):
	var table = synergies[aspect1.aspect_name]
	for entry in table:
		if entry[0] == aspect2.aspect_name:
			return entry[1]
	return null
		
