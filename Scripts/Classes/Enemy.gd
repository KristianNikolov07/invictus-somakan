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

var invincibility_timer = Timer.new()

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
		node.set_item(loot)
		node.global_position = global_position
		get_node("../").add_child(node)

func damage(hitbox: Hitbox, knockback) -> void:
	var is_crit = Utils.calculate_crit(hitbox.get_crit_chance())
	set_collision_layer_value(1, false)
	invincibility_timer.start()
	if !can_be_knockedback:
		knockback = 0
	velocity.x = 1600 * knockback
	velocity.y = -500 * abs(knockback)
	var damage = hitbox.get_damage() * (hitbox.get_crit_mult() if is_crit else 1)
	Utils.summon_damage_number(self, damage, Color.ORANGE_RED if is_crit else Color.WHITE, damage_number_scale, damage_number_duration)
	hp -= damage
	if hp <= 0:
		drop_loot()
		queue_free()

func _on_invincibility_timer_timeout():
	set_collision_layer_value(1, true)
