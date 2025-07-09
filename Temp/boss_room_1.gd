extends Node2D


func _on_check_door_timeout() -> void:
	print($DoorChecker.get_overlapping_bodies())
	if $DoorChecker.get_overlapping_bodies().size() <= 0:
		$Doors/AnimationPlayer.play("close")
		$DoorChecker.queue_free()
		$ArenaCam.enabled = true
		$ArenaCam.make_current()
