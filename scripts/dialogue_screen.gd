extends Control
class_name DialogueScreen

var _step:float = 0.05

var _id:int = 0
var data:Dictionary = {}

var _text_finished:bool = false 

@export_category("Objects")
@export var _name: Label = null
@export var _dialog: RichTextLabel = null
@export var _faceset: TextureRect = null

func _ready() -> void:
	_initialize_dialog()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if _text_finished:
			_id += 1
			if _id >= data.size():
				queue_free()  # Fim do diálogo
				return
			_initialize_dialog()
		else:
			_dialog.visible_characters = _dialog.text.length()
			_text_finished = true


func _initialize_dialog() -> void:
	if _id >= 0 and _id < data.size():
		_name.text = data[_id]["title"]
		_dialog.text = data[_id]["dialog"]
		_faceset.texture = load(data[_id]["faceset"])
		
		_dialog.visible_characters = 0
		_text_finished = false
		display_text_gradually()

func display_text_gradually() -> void:
	while _dialog.visible_characters < _dialog.text.length():
		await get_tree().create_timer(_step).timeout
		_dialog.visible_characters += 1
		
		if Input.is_action_pressed("ui_accept"):  # Completa o texto instantaneamente
			_dialog.visible_characters = _dialog.text.length()
			return
	_text_finished = true

func reset_dialogue() -> void:
	_id = 0
	_step = 0.05
	if data.size() > 0:
		_initialize_dialog()
