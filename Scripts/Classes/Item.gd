extends Resource
class_name Item

enum Type {
	RESOURCE,
	ASPECT,
	BLUEPRINT,
	CONSUMABLE,
	WEAPON
}

@export var item_name: String
@export var icon: Texture2D
@export var type: Type
var amount = 1
