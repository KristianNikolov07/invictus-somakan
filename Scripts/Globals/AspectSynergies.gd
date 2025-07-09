extends Node

var synergies = {
	"Fire": [
		["Poison", "Chemical Burn"], #more demig baybeee
		["Freeze", "Frostburn"], #fire demig but with slow down
		["Critical Chance", "Inferno"], #fire but with crits
		["Critical Damage", "Explosion"] #kablooie
	],
	"Poison": [
		["Fire", "Chemical Burn"],
		["Freeze", "Wither"], #wither will slow down and make them deal less demig
		["Critical Chance", "Toxic"], #faster ticking poison
		["Critical Damage", "Instant Poison"] #instantly fills all charges for poison
	],
	"Freeze": [
		["Fire", "Frostburn"],
		["Poison", "Wither"],
		["Critical Chance", "Frostbite"], #has a 50% chance to insta freeze
		["Critical Damage", "Blizzard"] #increased damage on ice break
	],
	"Critical Chance": [
		["Fire", "Inferno"],
		["Poison", "Toxic"],
		["Freeze", "Frostbite"],
		["Critical Damage", "Bleed"] #stacks up until you crit, then a lot of damage gets unleashed
	],
	"Critical Damage": [
		["Fire", "Explosion"],
		["Poison", "Instant Poison"],
		["Freeze", "Blizzard"],
		["Critical Chance", "Bleed"]
	]
}
