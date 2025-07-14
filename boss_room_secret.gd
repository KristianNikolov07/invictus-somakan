extends Node2D


func _on_check_door_timeout() -> void:
	print($DoorChecker.get_overlapping_bodies())
	if $DoorChecker.get_overlapping_bodies().size() <= 0:
		$Doors/AnimationPlayer.play("close")
		$DoorChecker.queue_free()
		$ArenaCam.enabled = true
		$ArenaCam.make_current()
		$Music.play()
		await get_tree().create_timer(8).timeout
		$Boss/AnimationPlayer.play("intro")
		await $Boss/AnimationPlayer.animation_finished
		$Boss/AnimationPlayer.play("start")
		await $Boss/AnimationPlayer.animation_finished
		$Boss.start()


func _on_boss_dead() -> void:
	$Doors/AnimationPlayer.play("open")
	$Trapforms/AnimationPlayer.play_backwards("lower")
	$ArenaCam.enabled = false
