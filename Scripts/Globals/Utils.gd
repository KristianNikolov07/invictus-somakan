extends Node

func summon_damage_number(body: CharacterBody2D, damage: int, color: Color, scale: float, duration: float):
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

