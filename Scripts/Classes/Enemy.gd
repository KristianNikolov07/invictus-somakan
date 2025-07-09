extends CharacterBody2D
class_name Enemy

@export var speed = 150
@export var coll_damage = 5
@export var attack_damage = 15
@export var knockback_strength = 1.5
@export var hp = 20
@export var coll_knockback = 1
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
var bleed_stacks: int = 0

var invincibility_timer = Timer.new()

var fire_status_scene = preload("res://Scenes/StatusEffects/fire.tscn")

func _ready() -> void:
	invincibility_timer.wait_time = invincibility_length
	invincibility_timer.timeout.connect(_on_invincibility_timer_timeout)
	invincibility_timer.autostart = true
	add_child(invincibility_timer)

func set_is_moving(_is_moving : bool):
	is_moving = _is_moving

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
	damage *= 2 if crit_chance >= randf_range(0, 1) else 1
	Utils.summon_damage_number(self, damage, number_color, damage_number_scale / 1.3, damage_number_duration / 1.3)
	hp -= damage
	if hp <= 0:
		drop_loot()
		queue_free()

func _on_invincibility_timer_timeout():
	set_collision_layer_value(1, true)
