extends Node3D

var prev_mouse_position

# Lista de peças que serão rotacionadas
var pieces = []

# Defina os alvos de posição e rotação para cada peça
var target_transforms = {
	"hibyscus_petal5": Transform3D(Basis.from_euler(Vector3(deg_to_rad(36.9), deg_to_rad(-121.8), deg_to_rad(70.7))), Vector3(0.891, 0.99, 0.088)),
	"hibyscus_petal4": Transform3D(Basis.from_euler(Vector3(deg_to_rad(73.3), deg_to_rad(136.2), deg_to_rad(-23))), Vector3(0.601, 1.042, -0.001)),
	"hibyscus_petal3": Transform3D(Basis.from_euler(Vector3(deg_to_rad(11.7), deg_to_rad(73.4), deg_to_rad(-74.3))), Vector3(0.537, 0.78, -0.101)),
	"hibyscus_petal2": Transform3D(Basis.from_euler(Vector3(deg_to_rad(-67.7), deg_to_rad(28.2), deg_to_rad(-45.9))), Vector3(0.74, 0.568, -0.089)),
	"hibyscus_petal": Transform3D(Basis.from_euler(Vector3(deg_to_rad(-37.2), deg_to_rad(-97.9), deg_to_rad(70.6))), Vector3(0.996, 0.714, 0.045)),
	"hibyscus_stem": Transform3D(Basis.from_euler(Vector3(deg_to_rad(-47.9), deg_to_rad(52.4), deg_to_rad(-66.8))), Vector3(0.625, 0.689, 0.307)),
	"hibyscus_polinator": Transform3D(Basis.from_euler(Vector3(deg_to_rad(-47.9), deg_to_rad(52.4), deg_to_rad(-66.8))), Vector3(0.789, 0.844, 0.003))
}

var tolerance_position = 0.05  # Tolerância para posição
var tolerance_rotation = 45.0   # Tolerância para rotação (graus)

func _ready():
	# Adiciona as peças na lista
	for piece_name in target_transforms.keys():
		pieces.append(get_node(piece_name))
	
	print_piece_states()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				prev_mouse_position = get_viewport().get_mouse_position()
			else:
				prev_mouse_position = null

	if event is InputEventMouseMotion and prev_mouse_position:
		var next_mouse_position = get_viewport().get_mouse_position()
		var delta_position = next_mouse_position - prev_mouse_position

		# Rotaciona todas as peças
		for piece in pieces:
			piece.rotate(Vector3(-1, 0, 0), -delta_position.y * 0.01)
			piece.rotate(Vector3(0, 0, 1), -delta_position.x * 0.01)

		prev_mouse_position = next_mouse_position

		# Exibe as posições e ângulos das peças
		print_piece_states()

		if check_all_pieces_aligned():
			on_puzzle_complete()

	# Verifica se a tecla "cheat_2" foi pressionada
	if event.is_action_pressed("cheat_2"):
		cheat_complete_puzzle()

func print_piece_states():
	# Itera pelas peças e imprime as informações de posição e ângulo
	for piece in pieces:
		var piece_position = piece.transform.origin
		var piece_rotation = piece.rotation_degrees
		print(piece.name, " - Posição: ", piece_position, " Ângulos: ", piece_rotation)

func check_all_pieces_aligned() -> bool:
	# Verifica se todas as peças estão alinhadas com os alvos
	for piece_name in target_transforms.keys():
		var target_transform = target_transforms[piece_name]
		var current_piece = get_node(piece_name)
		var current_transform = current_piece.transform

		var pos_diff = target_transform.origin.distance_to(current_transform.origin)
		var rot_diff = target_transform.basis.get_euler().distance_to(current_transform.basis.get_euler())

		if pos_diff > tolerance_position or rot_diff > deg_to_rad(tolerance_rotation):
			return false
	return true

func cheat_complete_puzzle():
	# Ajusta todas as peças para os alvos
	for piece_name in target_transforms.keys():
		var piece = get_node(piece_name)
		var target_transform = target_transforms[piece_name]
		
		# Preserva a escala atual
		var current_scale = piece.scale
		
		# Define a posição e rotação
		piece.transform = target_transform
		
		# Restaura a escala
		piece.scale = current_scale

	print("Puzzle completado via cheat!")
	on_puzzle_complete()

func on_puzzle_complete():
	print("Você conseguiu!")
	$Label3D.visible = true
	set_process_input(false)
	await get_tree().create_timer(2.5).timeout
	_change_scene()
	$Label3D.visible = false
	Global.sucess = true

func _change_scene():
	get_tree().change_scene_to_file("res://cenas/main_scenes/oficial-forest.tscn")
