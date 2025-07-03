extends Enemy
class_name FlyingEnemy

var target : CharacterBody2D
var retarget_timer = Timer.new()

func _ready() -> void:
	super._ready()
	retarget_timer.wait_time = 1
	retarget_timer.timeout.connect(set_new_target)
	retarget_timer.autostart = true
	add_child(retarget_timer)
	set_new_target()

func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, delta * speed)

func set_new_target():
	var closest_player : CharacterBody2D
	for player in get_tree().get_nodes_in_group("Players"):
		if closest_player == null:
			closest_player = player
		elif closest_player.global_position.distance_to(global_position) > player.global_position.distance_to(global_position):
			closest_player = player
	target = closest_player
