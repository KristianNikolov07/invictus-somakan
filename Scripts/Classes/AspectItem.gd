extends Item
class_name AspectItem

@export var status_effect: PackedScene
@export var aspect_name: String
@export var crit_chance_mult: float = 1
@export var crit_damage_mult: float = 1
@export var summoned_on_impact: PackedScene

func apply_crit_stats(hitbox: Hitbox):
	hitbox.crit_chance *= crit_chance_mult
	hitbox.crit_mult *= crit_damage_mult
	
func unapply_crit_stats(hitbox: Hitbox):
	hitbox.crit_chance /= crit_chance_mult
	hitbox.crit_mult /= crit_damage_mult

func apply_effect(body: CharacterBody2D):
	if status_effect != null and body.has_method("apply_status_effect"):
		body.apply_status_effect(status_effect)
	if summoned_on_impact != null:
		var summoned = summoned_on_impact.instantiate()
		summoned.position = body.position
		body.get_parent().add_child(summoned)
