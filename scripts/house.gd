extends Node2D
class_name Level

const _DIALOG_SCREEN: PackedScene = preload("res://cenas/HUDs/dialogue_screen.tscn")
const OBJECTIVE_HUD: PackedScene = preload("res://GUI/objective_hud.tscn")

var _player_in_area: bool = false
var _dialogue_active: bool = false
var _dialogue_completed: bool = false
var _dialog_data: Dictionary = {}

@export_category("Objects")
@export var _hud: CanvasLayer = null
	
var _current_dialogue: DialogueScreen = null

func which_dialog() -> Dictionary:
	if Global.dialog_id == 0:
		self._dialog_data = {
			0: {
				"faceset": "res://assets/nimue/faceset/faceset-nimue.png",
				"dialog": "Ah, olá! Você deve ser minha vizinha.",
				"title": "Nimue"
			},
			
			1: {
				"faceset": "res://assets/vizinhos/npc1-faceset.png",
				"dialog": "Isso mesmo! Sou Kaitlyn, moro na casa ao lado. Queria dar as boas-vindas. Vi que você se mudou há poucos dias e pensei em passar aqui.",
				"title": "Kaitlyn"
			},
			2: {
				"faceset": "res://assets/nimue/faceset/faceset-nimue.png",
				"dialog": "Muito obrigada, Kaitlyn! Eu sou a Nimue. Estou tentando arrumar as coisas, mas é tanta bagunça... (risos) Quer entrar?",
				"title": "Nimue"
			},
			3: {
				"faceset":  "res://assets/vizinhos/npc1-faceset.png",
				"dialog": "Claro, obrigada! (entra e observa as caixas espalhadas) Mudanças são sempre assim, né? Um caos no começo, mas depois tudo se ajeita.",
				"title": "Kaitlyn"
			},
			4: {
				"faceset": "res://assets/nimue/faceset/faceset-nimue.png",
				"dialog": "Exatamente. Ainda estou tentando lembrar onde coloquei metade das minhas coisas. Mas me conta, está tudo bem com você? Você parece um pouco cansada...",
				"title": "Nimue"
			},
			5: {
				"faceset":  "res://assets/vizinhos/npc1-faceset.png",
				"dialog": "Ah, você percebeu? (sorri meio sem graça) Pois é, meu trabalho tem me consumido. Estou em um projeto enorme, e tem sido noites e noites mal dormidas.",
				"title": "Kaitlyn"
			},
			6: {
				"faceset": "res://assets/nimue/faceset/faceset-nimue.png",
				"dialog": "Nossa, imagino o quanto deve ser puxado... Não é fácil lidar com a falta de sono.",
				"title": "Nimue"
			},
			7: {
				"faceset":  "res://assets/vizinhos/npc1-faceset.png",
				"dialog": "Não mesmo. Eu até tento desligar a mente antes de dormir, mas às vezes parece impossível.",
				"title": "Kaitlyn"
			},
			8: {
				"faceset": "res://assets/nimue/faceset/faceset-nimue.png",
				"dialog": "Sabe, acho que posso ajudar. Eu tinha um chá relaxante incrível que costumava usar nessas situações. Ele me ajudava a dormir como uma pedra. Só preciso lembrar em qual dessas caixas ele está...",
				"title": "Nimue"
			},
			9: {
				"faceset":  "res://assets/vizinhos/npc1-faceset.png",
				"dialog": "(rindo) Não se preocupe, não quero te dar mais trabalho no meio dessa bagunça!",
				"title": "Kaitlyn"
			},
			10: {
				"faceset": "res://assets/nimue/faceset/faceset-nimue.png",
				"dialog": "Imagina! Vai ser uma desculpa para eu tentar organizar essas caixas mais rápido. Vou dar uma procurada depois e te levo, pode ser?",
				"title": "Nimue"
			},
			11: {
				"faceset":  "res://assets/vizinhos/npc1-faceset.png",
				"dialog": "Poxa, Nimue, muito obrigada. Seria ótimo!",
				"title": "Kaitlyn"
			},
			12: {
				"faceset": "res://assets/nimue/faceset/faceset-nimue.png",
				"dialog": "Não precisa agradecer. Somos vizinhas, não é? Acho que temos que nos ajudar.",
				"title": "Nimue"
			},
			13: {
				"faceset":  "res://assets/vizinhos/npc1-faceset.png",
				"dialog": "Com certeza! E se precisar de algo também, pode contar comigo.",
				"title": "Kaitlyn"
			}
		}

		Global.dialog_id = 1

	elif Global.dialog_id == 1 and Global.sucess == 0:
		self._dialog_data = {
			0: {
				"faceset":  "res://assets/vizinhos/npc1-faceset.png",
				"dialog": "Estarei esperando pelo chá acalmante",
				"title": "Kaitlyn"
			}
		}

	elif Global.dialog_id == 1 and Global.sucess == 1:
		self._dialog_data = {
			0: {
				"faceset": "res://assets/nimue/faceset/faceset-nimue.png",
				"dialog": "Olá, obrigada por vir. Trouxe o que havia prometido, espero que goste!",
				"title": "Nimue"
			},
			1: {
				"faceset": "res://assets/vizinhos/npc1-faceset.png",
				"dialog": "Nossa, agradeço bastante! Irei testar imediatamente!",
				"title": "Kaitlyn"
			},
			2: {
				"faceset": "res://assets/vizinhos/npc1-faceset.png",
				"dialog": "Os efeitos são realmente ótimos. Se você não se importar, irei voltar para casa e tirar um descanso merecido",
				"title": "Kaitlyn"
			},
			3: {
				"faceset": "res://assets/nimue/faceset/faceset-nimue.png",
				"dialog": "Não se preocupe! Espero que tenha ajudado!",
				"title": "Nimue"
			}
		}

		Global.dialog_id = 2

	return self._dialog_data


func restart_scene():
	if _current_dialogue:
		_current_dialogue.queue_free()
	
	_current_dialogue = _DIALOG_SCREEN.instantiate() as DialogueScreen
	if not _current_dialogue:
		print("Erro: Não foi possível instanciar DialogueScreen.")
		return
		
	_current_dialogue.data = which_dialog()
	if _hud:
		_hud.add_child(_current_dialogue)
	else:
		print("Erro: HUD não está configurado.")
	
	_current_dialogue.reset_dialogue()

	_dialogue_active = true  # Marca que o diálogo está ativo
	_current_dialogue.connect("tree_exited", Callable(self, "_on_dialogue_completed"))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("dialog") and _player_in_area and not _dialogue_completed and not _dialogue_active:
		$vizinha/Label.hide()
		restart_scene()

	if _dialogue_active:
		# Bloqueia todas as ações, exceto "ui_accept"
		var actions = InputMap.get_actions()
		for action in actions:
			if action != "ui_accept" or "pause":
				Input.action_release(action)
	
	if Global.dialog_id == 2:
		
		pass

func _on_dialogue_trigger_body_entered(body: Node2D) -> void:
	print("Entrou: ", body.name)
	if body.name == "player":
		_player_in_area = true
		if _dialogue_completed:
			$vizinha/Label.hide()
		else:
			$vizinha/Label.show()

func _on_dialogue_trigger_body_exited(body: Node2D) -> void:
	if body.name == "player":
		$vizinha/Label.hide()
		_player_in_area = false

func _on_dialogue_completed():
	_dialogue_completed = true
	_dialogue_active = false  # Libera as ações novamente
	# Atualiza o texto da label no HUD global
	if Global.sucess == 0 and Global.dialog_id == 1:
		$HUD_objetivo/objective_hud.show()
