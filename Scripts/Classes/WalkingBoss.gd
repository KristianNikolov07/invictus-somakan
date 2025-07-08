extends WalkingEnemy
class_name WalkingBoss

@export var attack_delay: float = 3

var attacks: Array[String] = []
var attack_timer: Timer = Timer.new()

func _ready():
	super._ready()
	attack_timer.wait_time = attack_delay
	attack_timer.connect("timeout", act)
	attack_timer.start()

func act():
	call(attacks[randi_range(0, len(attacks) - 1)])
