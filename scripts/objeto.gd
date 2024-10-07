extends RigidBody3D

var rotating = false
var prev_mouse_position

var target_rotation = Vector2(30, 40)
var tolerance = 10

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				rotating = true
				prev_mouse_position = get_viewport().get_mouse_position()
			else:
				rotating = false

	if event is InputEventMouseMotion and rotating:
		var next_mouse_position = get_viewport().get_mouse_position()
		var delta_position = next_mouse_position - prev_mouse_position

		rotate(Vector3(-1, 0, 0), -delta_position.y * 0.01)
		rotate(Vector3(0, 0, 1), -delta_position.x * 0.01)

		prev_mouse_position = next_mouse_position

		var current_rotation = rotation_degrees
		print("Rotação Atual: ", current_rotation)

		if is_near_target_rotation():
			print("Você conseguiu!")
			$"../Label3D".visible = true
			await get_tree().create_timer(2.5).timeout
			_change_scene()
			$"../Label3D".visible = false

func is_near_target_rotation() -> bool:
	var current_rotation = rotation_degrees
	return abs(current_rotation.x - target_rotation.x) <= tolerance and \
		abs(current_rotation.y - target_rotation.y) <= tolerance 

func _change_scene():
		get_tree().change_scene_to_file("res://cenas/forest.tscn")
