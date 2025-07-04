extends Node
@export var attack_damage = 10
@export var crit_chance = 0.1
@export var crit_mult = 2
@export var knockback_amount = 1
var dir = 1

func _ready() -> void:
	$Sword.set_crit_chance(crit_chance)
	$Sword.set_crit_mult(crit_mult)

func hit(direction : int):
	if direction == -1:
		$AnimationPlayer.play("Left")
		dir = -1
	else:
		$AnimationPlayer.play("Right")
		dir = 1


func _on_sword_body_entered(body: Node2D) -> void:
	if body.has_method("damage") and body.is_in_group("Enemies"):
		body.damage($Sword, knockback_amount * dir)
