extends Control

func _process(_delta: float) -> void:
	if visible:
		if Input.is_action_just_pressed("ui_right"):
			$next.emit_signal("pressed")
		if Input.is_action_just_pressed("ui_left"):
			$prev.emit_signal("pressed")
		if Input.is_action_just_pressed("ui_text_backspace"):
			$fechar.emit_signal("pressed")
