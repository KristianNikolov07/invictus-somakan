extends Node2D
class_name StatusEffect

@export var damage: int = 5
@export var tick_time: float = 1
@export var apply_time: float = 5
@export var needed_stacks: int = 3
@export var crit_chance: float = 0.0
var remaining_timer: Timer = Timer.new()
var tick_timer: Timer = Timer.new()
var stacks: int = 0
@export var damage_number_color: Color = Color.WHITE

func _ready():
	remaining_timer.wait_time = apply_time
	remaining_timer.connect("timeout", end_effect)
	remaining_timer.one_shot = true
	add_child(remaining_timer)
	tick_timer.wait_time = tick_time
	tick_timer.connect("timeout", act)
	tick_timer.one_shot = false
	add_child(tick_timer)

func add_stack(amount:= 1):
	stacks += amount
	if stacks >= needed_stacks:
		stacks = 0
		if remaining_timer.is_stopped():
			start_effect()
		if not remaining_timer.is_stopped():
			remaining_timer.stop()
		remaining_timer.start()
		if not tick_timer.is_stopped():
			tick_timer.stop()
		tick_timer.start()

func start_effect():
	pass

func act():
	pass

func end_effect():
	get_parent().remove_status_effect(self)
	queue_free()
	
func on_hit(hitbox: Hitbox, damage: int, knockback):
	pass

#func _on_tick_timer_timeout():
	#act()
