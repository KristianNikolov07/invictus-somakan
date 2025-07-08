extends WalkingBoss

# ribarang -> hornet needle throw basically
# smash -> takes out his arm and smashes the ground in front
# charge -> copy the zombie ram but make it continuous
# blitz -> takes out rib to do a quick combo

var ribarang_scene = preload("res://Scenes/Projectiles/ribarang.tscn")


func _ready():
	super._ready()
	attacks.append("ribarang")
	attacks.append("smash")
	attacks.append("charge")
	attacks.append("blitz")

func ribarang():
	$AttackTimers/RibarangTimer.start()

func smash():
	$AttackTimers/SmashTimer.start()
	
func charge():
	pass
	
func blitz():
	pass
	
func _on_ribarang_timer_timeout() -> void:
	#ar ribarang = ribarang_scene.instantiate()
	pass

func _on_smash_timer_timeout() -> void:
	pass # Replace with function body.
