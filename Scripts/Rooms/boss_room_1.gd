extends Node2D


func _on_check_door_timeout() -> void:
	print($DoorChecker.get_overlapping_bodies())
	if $DoorChecker.get_overlapping_bodies().size() <= 0:
		$Doors/AnimationPlayer.play("close")
		$DoorChecker.queue_free()
		$ArenaCam.enabled = true
		$ArenaCam.make_current()
		await $Doors/AnimationPlayer.animation_finished
		$Boss/Attacks.play("intro")
		await $Boss/Attacks.animation_finished
		$Boss.start()


func _on_boss_dead() -> void:
	$Doors/AnimationPlayer.play("open")
	$Trapforms/AnimationPlayer.play_backwards("lower")
