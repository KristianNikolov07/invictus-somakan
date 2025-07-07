extends Node

var items : Array[Item]
var weapon1 : Item
var weapon2 : Item
var weapon1_aspects : Array[Item]
var weapon2_aspects : Array[Item]
var consumables : Array[Item]

func _ready() -> void:
	items.resize(5)
	weapon1_aspects.resize(2)
	weapon2_aspects.resize(2)
	consumables.resize(2)
