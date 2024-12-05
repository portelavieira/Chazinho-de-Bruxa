extends Control

@onready var page1 = $Page1
@onready var page2 = $Page2
@onready var page3 = $Page3

@onready var forward = $Forward
@onready var backward = $Backward

var page_counter = 1
var controller = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("skip"):
		page_counter += 1
	
	if Input.is_action_just_pressed("back"):
		if page_counter > 1:
			page_counter -= 1
	
	if page_counter > 1:
		backward.show()
	else:
		backward.hide()
	
	if page_counter == 1:
		page1.show()
		page2.hide()
		page3.hide()
		
	if page_counter == 2:
		page1.hide()
		page2.show()
		page3.hide()
		
	if page_counter == 3:
		page1.hide()
		page2.hide()
		page3.show()
		
	if page_counter >= 4:
		page_counter = 4
		
	if page_counter == 4:
		get_tree().change_scene_to_file("res://cenas/main_scenes/house.tscn")
