extends Enemy
class_name WalkingEnemy

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
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction
	if target != null:
		if target.global_position.x < global_position.x:
			direction = -1
		else:
			direction = 1
		
		if direction and (target.global_position - global_position).abs().x > FOLLOW_DEADZONE and is_moving:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	
	if is_frozen():
		velocity.x = 0
				
	move_and_slide()

func set_new_target():
	var closest_player : CharacterBody2D
	for player in get_tree().get_nodes_in_group("Players"):
		if closest_player == null:
			closest_player = player
		elif closest_player.global_position.abs().x - global_position.abs().x > player.global_position.abs().x - global_position.abs().x:
			closest_player = player
	target = closest_player
