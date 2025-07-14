class_name ScreenShaker2D extends Node

# THIS NODE IS INTENDED FOR USE ON CAMERA2D ONLY!
# THIS NODE IS NOT INTENDED TO BE USED ON CAMERA3D

@export var camera: Camera2D
var origin: Vector2
var intensity: float
var decrement: float
var is_slowed: bool
var slow_factor: float


func _ready() -> void:
	var whole_timer := Timer.new()
	whole_timer.name = "WholeShake"
	whole_timer.one_shot = true
	var shake_timer := Timer.new()
	shake_timer.name = "Shake"
	shake_timer.wait_time = 0.01
	
	add_child(whole_timer)
	add_child(shake_timer)
	whole_timer.timeout.connect(Callable(self, "_on_whole_shake_timeout"))
	shake_timer.timeout.connect(Callable(self, "_on_shake_timeout"))


func set_camera(_camera: Camera2D):
	camera = _camera


func shake_screen(length: float = 1, _intensity: float = 3, _is_slowed: bool = false, _slow_factor: float = 75) -> void:
	shake_stop()
	$WholeShake.start(length)
	$Shake.start()
	
	is_slowed = _is_slowed
	intensity = _intensity
	slow_factor = _slow_factor
	origin = camera.global_position
	
	if is_slowed:
		decrement = intensity / (slow_factor*length)


func shake_stop() -> void:
	if $WholeShake.is_stopped() and $Shake.is_stopped(): return
	$WholeShake.stop()
	$Shake.stop()
	camera.global_position = origin


func _on_whole_shake_timeout() -> void:
	$Shake.stop()
	camera.global_position = origin


func _on_shake_timeout() -> void:
	var shakerX = randf_range(-intensity, intensity)
	var shakerY = randf_range(-intensity, intensity)
	
	camera.global_position.x = origin.x + shakerX
	camera.global_position.y = origin.y + shakerY
	
	if is_slowed:
		intensity = move_toward(intensity, 0, decrement)
