extends Node
@export var attack_damage = 10
@export var crit_chance = 0.1
@export var crit_mult = 2
@export var knockback_amount = 1
var dir = 1
var is_down = false

func _ready() -> void:
	$Mace.set_crit_chance(crit_chance)
	$Mace.set_crit_mult(crit_mult)

func hit(direction : int):
	if !is_down:
		if direction == -1:
			$AnimationPlayer.play("LeftDown")
			dir = -1
		else:
			$AnimationPlayer.play("RightDown")
			dir = 1
		is_down = true
		$Cooldown.start()
	else:
		if direction == -1:
			$AnimationPlayer.play("LeftUp")
			dir = -1
		else:
			$AnimationPlayer.play("RightUp")
			dir = 1
		is_down = false


func _on_sword_body_entered(body: Node2D) -> void:
	if body.has_method("damage") and body.is_in_group("Enemies"):
		body.damage($Mace, knockback_amount * dir)


func _on_cooldown_timeout() -> void:
	is_down = false
