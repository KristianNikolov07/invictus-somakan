extends Weapon
var duration = 1.0
@export var charge_speed = 2
@export var duration_limit = 10
var is_charging = false
var is_damageing = false

@rpc("any_peer", "call_local", "reliable")
func hit(direction: int):
	duration = 1
	is_charging = true

func _physics_process(delta: float) -> void:
	if is_charging:
		duration += delta * charge_speed
		if duration >= duration_limit:
			start_damageing()

func _input(event: InputEvent) -> void:
	if event.is_action_released("Attack"):
		if is_charging:
			start_damageing()

func start_damageing():
	is_charging = false
	$Duration.wait_time = duration
	$Duration.start()
	is_damageing = true

func _on_hit_cooldown_timeout() -> void:
	if is_damageing:
		for body in $Hitbox.get_overlapping_bodies():
			if body.has_method("damage") and body.is_in_group("Enemies"):
				body.damage.rpc($Hitbox.get_path(), 0)


func _on_duration_timeout() -> void:
	is_damageing = false
