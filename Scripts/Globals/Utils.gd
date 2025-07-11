extends Node

const explosion := preload("res://Scenes/explosion.tscn")


func summon_damage_number(body: CharacterBody2D, damage: int, color: Color, scale: float, duration: float):
	if damage > 0:
		var damage_number = DamageNumber.new()
		body.get_parent().add_child(damage_number)
		damage_number.text = str(damage)
		damage_number.global_position = body.global_position + Vector2(0, -75)
		damage_number.set_duration(duration)
		damage_number.add_theme_color_override("font_color", color)
		damage_number.scale = Vector2(scale, scale)
		damage_number.start_playing()

func calculate_crit(crit_chance: float):
	return true if randf_range(0, 1) < crit_chance else false


func summon_explosion(pos: Vector2, size: float = 1, damage: int = 15, knockback: float = 1, speed_scale: float = 1.2, can_hit_players: bool = false, can_hit_enemies: bool = true) -> Area2D:
	var new_expl = explosion.instantiate()
	new_expl.global_position = pos
	new_expl.scale = Vector2(size, size)
	new_expl.damage = damage
	new_expl.knockback = knockback
	new_expl.speed_scale = speed_scale
	new_expl.can_hit_players = can_hit_players
	new_expl.can_hit_enemies = can_hit_enemies
	
	return new_expl
