extends Node2D

func _on_portal_body_entered(body: Node2D) -> void:
	if body.name == "player":
		_change_scene()

func _change_scene():
		get_tree().change_scene_to_file("res://cenas/forest.tscn")
