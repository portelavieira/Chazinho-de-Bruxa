extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Global.sucess = 0
	if Input.is_action_just_pressed("dialog"):
		get_tree().change_scene_to_file("res://cenas/main_scenes/house.tscn")
