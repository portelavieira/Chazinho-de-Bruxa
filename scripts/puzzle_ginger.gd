extends Node3D

var prev_mouse_position

# Lista de peças que serão rotacionadas
var pieces = []

# Defina os alvos de posição e rotação para cada peça
var target_transforms = {
	"ginger_root1": Transform3D(Basis.from_euler(Vector3(deg_to_rad(35.96179), deg_to_rad(120.6629), deg_to_rad(19.19637))), Vector3(-0.445038, 0.973305, -0.474422)),
	"ginger_root2": Transform3D(Basis.from_euler(Vector3(deg_to_rad(38.0218), deg_to_rad(112.025), deg_to_rad(13.99183))), Vector3(-0.000505, 0.653528, -0.359238)),
	"ginger_root3": Transform3D(Basis.from_euler(Vector3(deg_to_rad(36.87164), deg_to_rad(117.2198), deg_to_rad(17.15197))), Vector3(-0.445599, 0.973788, -0.078369)),
	"ginger_root4": Transform3D(Basis.from_euler(Vector3(deg_to_rad(39.71091), deg_to_rad(100.0396), deg_to_rad(6.453472))), Vector3(-0.367723, 0.882392, 0.49977)),
	"ginger_root5": Transform3D(Basis.from_euler(Vector3(deg_to_rad(39.3499), deg_to_rad(103.5588), deg_to_rad(8.693812))), Vector3(-0.082397, 0.638916, 0.171038)),
}

var tolerance_position = 0.05  # Tolerância para posição
var tolerance_rotation = 15.0   # Tolerância para rotação (graus)

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

	# Verifica se a tecla "cheat_3" foi pressionada
	if event.is_action_pressed("cheat_3"):
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

		# Verifica posição
		var pos_diff = target_transform.origin.distance_to(current_transform.origin)
		if pos_diff > tolerance_position:
			print(piece_name, " posição desalinhada: Diferença = ", pos_diff)
			return false

		# Verifica rotação
		var current_rotation = current_piece.rotation_degrees
		var target_rotation = target_transform.basis.get_euler() * 180.0 / PI
		var rot_diff = abs(current_rotation - target_rotation)
		if rot_diff.x > tolerance_rotation or rot_diff.y > tolerance_rotation or rot_diff.z > tolerance_rotation:
			print(piece_name, " rotação desalinhada: Diferença = ", rot_diff)
			return false

	return true

func cheat_complete_puzzle():
	# Ajusta todas as peças para os alvos
	for piece_name in target_transforms.keys():
		var piece = get_node(piece_name)
		var target_transform = target_transforms[piece_name]
		var current_scale = piece.scale
		piece.transform = target_transform
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
	Global.sucess = 3

func _change_scene():
	get_tree().change_scene_to_file("res://cenas/main_scenes/oficial-forest.tscn")
