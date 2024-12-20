extends Area2D

func _ready() -> void:
	$magic.play("magic")
	$magic/door.play("door_closes")

func _process(_delta: float) -> void:
	pass

# Mapeamento das cenas
var scene_map: Dictionary = {
	"oficial-forest": "res://cenas/main_scenes/house.tscn",
	"house": "res://cenas/main_scenes/oficial-forest.tscn"
}

func _change_scene() -> void:
	# Verifica as condições antes de mudar a cena
	if (Global.dialog_id == 0 or Global.dialog_id == 2) and Global.sucess == 0:
		print("Portal bloqueado devido às condições globais.")
		return

	# Obtém o caminho da cena atual
	var current_scene_path = get_tree().current_scene.name
	match current_scene_path:
		"oficial-forest":
			get_tree().change_scene_to_file("res://cenas/main_scenes/house.tscn")
		"house":
			get_tree().change_scene_to_file("res://cenas/main_scenes/oficial-forest.tscn")

func _on_animation_area_area_entered(_area: Area2D) -> void:
	$magic/door.play("door_open")

func _on_animation_area_area_exited(_area: Area2D) -> void:
	$magic/door.play("door_closes")

func _on_area_entered(body: Node) -> void:
	print("Entrou: ", body.name, ", Pai: ", body.get_parent().name) # Depuração para verificar o nó
	if body.name == "hitbox" and body.get_parent().name == "player":
		_change_scene()
