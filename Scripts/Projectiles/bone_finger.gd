extends Area2D

@export var damage = 15
var initial_speed: Vector2
var speed: float
var drop: float
var rot_speed: float
var planned_pos: Vector2


func _ready() -> void:
	initial_speed = Vector2(randf_range(-200, 200), randf_range(-450, -390))
	drop = randf_range(300, 380)
	rot_speed = randf_range(2, 5)


func _physics_process(delta: float) -> void:
	if not $StartAnim.is_stopped():
		position += initial_speed * delta
		rotation_degrees += rot_speed
		initial_speed = initial_speed.move_toward(Vector2.ZERO, drop*delta)
		rot_speed = move_toward(rot_speed, 0, delta*3)


func _on_start_anim_timeout() -> void:
	var anim: Animation = $AnimationPlayer.get_animation("snap").duplicate()
	anim.track_set_key_value(0, 0, position)
	anim.track_set_key_value(0, 1, planned_pos)
	anim.track_set_key_value(1, 0, rotation)
	$AnimationPlayer.get_animation_library("").add_animation("snap", anim)
	$AnimationPlayer.play("snap")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "snap":
		var anim = $AnimationPlayer.get_animation("fall").duplicate()
		anim.track_set_key_value(0, 0, position)
		anim.track_set_key_value(0, 1, position + Vector2(0, -60))
		anim.track_set_key_value(0, 2, position + Vector2(0, 1500))
		$AnimationPlayer.get_animation_library("").add_animation("fall", anim)
		$AnimationPlayer.play("ready")
	elif anim_name == "ready":
		$AnimationPlayer.play("fall")
	elif anim_name == "fall":
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		body.damage_amount(damage, 0)
