extends Node2D

var lines = [["???", "Finally... I made it."], ["???", "It's been so long..."]]
var is_line_finished = false
var current_line = 0
var is_arrow_up = 1

func _ready():
	display_next_line()
	
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept") or Input.is_action_pressed("Jump") and not is_line_finished:
		$LetterTimer.wait_time = 0.02
	else:
		$LetterTimer.wait_time = 0.06

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept") or event.is_action_pressed("Jump")) and is_line_finished:
		current_line += 1
		display_next_line()
	
func display_next_line():
	if current_line >= len(lines):
		get_tree().quit()
		return
	is_line_finished = false
	$PressArrow.visible = false
	$LetterTimer.start()
	$NameLabel.text = lines[current_line][0]
	$TextLabel.text = lines[current_line][1]
	$TextLabel.visible_characters = 0
	
func _on_letter_timer_timeout() -> void:
	var current_string = lines[current_line][1]
	if len(current_string) > $TextLabel.visible_characters:
		$TextLabel.visible_characters += 1
	else:
		$LetterTimer.stop()
		$PressArrow.visible = true
		is_line_finished = true
		
func _on_press_arrow_timer_timeout() -> void:
	$PressArrow.position += Vector2(0, 15 if is_arrow_up else -15)
	is_arrow_up = not is_arrow_up
