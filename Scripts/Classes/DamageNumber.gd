extends Label
class_name DamageNumber

var duration = 2

func start_playing():
	var alpha_tween = get_tree().create_tween()
	alpha_tween.tween_property(self, "modulate:a", 0, duration)
	alpha_tween.play()
	await alpha_tween.finished
	alpha_tween.kill()
	queue_free()

func get_duration():
	return duration

func set_duration(new_duration):
	duration = new_duration
