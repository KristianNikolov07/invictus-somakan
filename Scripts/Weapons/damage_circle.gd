extends Weapon
var duration = 1.0
@export var charge_speed = 2
@export var duration_limit = 10
var is_charging = false
var is_damageing = false

func hit(direction: int):
	duration = 1
	is_charging = true
	if direction < 0:
		$HoldLeft.show()
	else:
		$HoldRight.show()

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
	$HoldLeft.hide()
	$HoldRight.hide()
	$Sprite2D.show()

func _on_hit_cooldown_timeout() -> void:
	if is_damageing:
		for body in $Hitbox.get_overlapping_bodies():
			if body.has_method("damage") and body.is_in_group("Enemies"):
				var aspect: AspectItem = get_aspect_to_apply()
				if aspect != null:
					aspect.apply_crit_stats($Hitbox)
				body.damage($Hitbox, 0)
				if aspect != null:
					aspect.unapply_crit_stats($Hitbox)
					aspect.apply_effect(body)


func _on_duration_timeout() -> void:
	is_damageing = false
	$Sprite2D.hide()
