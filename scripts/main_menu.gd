extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/main_scenes/tutorial.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
