extends CharacterBody2D
class_name Enemy

@export var speed = 150
@export var coll_damage = 5
@export var attack_damage = 15
@export var knockback_strength: float = 1.5
@export var hp = 20
@export var coll_knockback: float = 1
@export var max_hp = 20
@export var parry_damage = 1
@export var parry_knockback_mult = 1
@export var invincibility_length = 0.5
@export var can_be_knockedback = true
@export var damage_number_scale: float = 2
@export var damage_number_duration: float = 2
const JUMP_VELOCITY = -400.0
const FOLLOW_DEADZONE = 1
@export var is_moving = true
var attacking = false
@export var loot : Item
const dropped_item_scene = preload("res://Scenes/Objects/dropped_item.tscn")
var active_status_effects: Array[StatusEffect] = []
var damage_mult: float = 1

var invincibility_timer = Timer.new()

func _ready() -> void:
	invincibility_timer.wait_time = invincibility_length
	invincibility_timer.timeout.connect(_on_invincibility_timer_timeout)
	invincibility_timer.autostart = true
	add_child(invincibility_timer)

func set_is_moving(_is_moving : bool):
	is_moving = _is_moving

func is_frozen():
	for status in active_status_effects:
		print(status.status_name)
		if status.status_name == "Freeze":
			if not status.remaining_timer.is_stopped():
				return status
				
	return null

func is_frostbitten():
	for status in active_status_effects:
		print(status.status_name)
		if status.status_name == "Frostbite":
			if not status.remaining_timer.is_stopped():
				return status
				
	return null

func is_blizzard():
	for status in active_status_effects:
		print(status.status_name)
		if status.status_name == "Blizzard":
			if not status.remaining_timer.is_stopped():
				return status
				
	return null

func is_bleeding():
	var bleed_color = Color.DARK_RED
	
	for status in active_status_effects:
		if status.status_name == "Bleed":
			return status
	
	return null

func parry():
	damage_amount(parry_damage, parry_knockback_mult)


func damage_amount(amount, knockback) -> void:
	Utils.summon_damage_number(self, amount, Color.WHITE, damage_number_scale, damage_number_duration)
	set_collision_layer_value(1, false)
	invincibility_timer.start()
	if !can_be_knockedback:
		knockback = 0
	velocity.x = 1600 * knockback
	velocity.y = -500 * abs(knockback)
	var frozen = is_frozen()
	if frozen:
		amount *= 2
		frozen.end_effect()
	var frostbitten = is_frostbitten()
	if frostbitten:
		amount *= 2
		frostbitten.end_effect()
	var blizzard = is_blizzard()
	if blizzard:
		amount *= 3
		blizzard.end_effect()
	hp -= amount
	if hp <= 0:
		drop_loot()
		queue_free()

func drop_loot():
	if loot != null:
		var node = dropped_item_scene.instantiate()
		node.get_node("Area").set_item(loot)
		node.global_position = global_position
		get_parent().call_deferred("add_child", node)

func damage(hitbox: Hitbox, knockback) -> void:
	var is_crit = Utils.calculate_crit(hitbox.get_crit_chance())
	set_collision_layer_value(1, false)
	invincibility_timer.start()
	if !can_be_knockedback:
		knockback = 0
	velocity.x = 1600 * knockback
	velocity.y = -500 * abs(knockback)
	var dam = hitbox.get_damage() * (hitbox.get_crit_mult() if is_crit else 1)
	var frozen = is_frozen()
	if frozen:
		dam *= 2
		frozen.end_effect()
	var frostbitten = is_frostbitten()
	if frostbitten:
		dam *= 2
		frostbitten.end_effect()
	var blizzard = is_blizzard()
	if blizzard:
		dam *= 3
		blizzard.end_effect()
	if is_crit:
		var bleeding = is_bleeding()
		if bleeding:
			bleeding.end_effect()
	Utils.summon_damage_number(self, dam, Color.ORANGE_RED if is_crit else Color.WHITE, damage_number_scale, damage_number_duration)
	hp -= dam
	if hp <= 0:
		drop_loot()
		queue_free()

func apply_status_effect(effect: PackedScene):
	var effect_node = effect.instantiate()
	for active_effect in active_status_effects:
		if active_effect.damage_number_color == effect_node.damage_number_color:
			active_effect.add_stack()
			effect_node.queue_free()
			return
	add_child(effect_node)
	active_status_effects.append(effect_node)
	effect_node.add_stack()
	
func remove_status_effect(effect: StatusEffect):
	for i in range(len(active_status_effects)):
		if active_status_effects[i].damage_number_color == effect.damage_number_color:
			active_status_effects.pop_at(i)
	
	
func status_damage(damage: int, number_color: Color, crit_chance: float = 0):
	var frozen = is_frozen()
	if frozen:
		frozen.end_effect()
	var frostbitten = is_frostbitten()
	if frostbitten:
		frostbitten.end_effect()
	var blizzard = is_blizzard()
	if blizzard:
		blizzard.end_effect()
	var is_crit = Utils.calculate_crit(crit_chance)
	if is_crit:
		damage *= 2
		var bleeding = is_bleeding()
		if bleeding:
			bleeding.end_effect()
	Utils.summon_damage_number(self, damage, number_color, damage_number_scale / 1.3, damage_number_duration / 1.3)
	hp -= damage
	if hp <= 0:
		drop_loot()
		queue_free()

func _on_invincibility_timer_timeout():
	set_collision_layer_value(1, true)

func get_hp():
	return hp

func get_max_hp():
	return max_hp
