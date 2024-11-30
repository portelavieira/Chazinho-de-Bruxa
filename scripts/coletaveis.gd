extends Area2D

func collect():
	queue_free()
	_change_scene()

func _change_scene():
		get_tree().change_scene_to_file("res://cenas/PuzzleSombras/node_3d.tscn")
