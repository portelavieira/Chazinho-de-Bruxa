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
	
	elif Global.dialog_id == 1 and Global.sucess == 2 or Global.sucess == 3:
		self._dialog_data = {
			0: {
				"faceset":  "res://assets/vizinhos/npc1-faceset.png",
				"dialog": "Tem certeza que esse é o chá que mencionou? Pode procurar com mais calma, estarei esperando.",
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
		
	elif Global.dialog_id == 2:
		self._dialog_data = {
			0: {
				"faceset": "res://assets/nimue/faceset/faceset-nimue.png",
				"dialog": "Olá! Você parece familiar...",
				"title": "Nimue"
			},
			1: {
				"faceset": "res://icon.svg",
				"dialog": "Oi, você deve ser a Nimue. Sou o irmão da Kaitlyn, meu nome é Ethan. Ela me falou muito bem de você e... do seu chá especial.",
				"title": "Ethan"
			},
			2: {
				"faceset": "res://assets/nimue/faceset/faceset-nimue.png",
				"dialog": "Ah, Ethan! É um prazer conhecê-lo. Fico feliz que o chá tenha ajudado a sua irmã. Como posso ajudar você?",
				"title": "Nimue"
			},
			3: {
				"faceset": "res://icon.svg",
				"dialog": "Bom... vou ser direto. Eu tenho sofrido com pressão alta ultimamente. O trabalho tem sido estressante, e meu médico recomendou que eu mudasse alguns hábitos. Kaitlyn mencionou que você parece saber bastante sobre chás. Será que você tem algo que possa me ajudar?",
				"title": "Ethan"
			},
			4: {
				"faceset": "res://assets/nimue/faceset/faceset-nimue.png",
				"dialog": "Entendo, isso realmente é algo sério. Mas acho que tenho exatamente o que você precisa! Espere aqui por um estante, logo trarei um chá que poderá te ajudar.",
				"title": "Nimue"
			},
			5: {
				"faceset": "res://icon.svg",
				"dialog": "Nossa, sério? Agradeço bastante! Estarei esperado por aqui.",
				"title": "Ethan"
			}
		}
		Global.dialog_id = 3

	elif Global.dialog_id == 3 and Global.sucess != 2:
		self._dialog_data = {
			0: {
				"faceset":  "res://icon.svg",
				"dialog": "Não se preocupe, estarei esperando aqui. Pode olhar suas coisas com calma.",
				"title": "Ethan"
			}
		}

	elif Global.dialog_id == 3 and Global.sucess == 2:
		self._dialog_data = {
			0: {
				"faceset": "res://assets/nimue/faceset/faceset-nimue.png",
				"dialog": "Aqui está o chá que prometi. Se chama 'chá de hibisco' Preparei uma porção para você experimentar. É simples de fazer, basta adicionar água quente e deixar em infusão por alguns minutos.",
				"title": "Nimue"
			},
			1: {
				"faceset": "res://icon.svg",
				"dialog": "Muito obrigado, Nimue. Vou seguir suas instruções e testar hoje mesmo!",
				"title": "Ethan"
			},
			2: {
				"faceset": "res://assets/nimue/faceset/faceset-nimue.png",
				"dialog": "Fico feliz em ajudar, Ethan. Me avise como se sente depois. E não hesite em voltar se precisar de mais alguma coisa.",
				"title": "Nimue"
			},
			3: {
				"faceset": "res://icon.svg",
				"dialog": "Pode deixar. Mais uma vez, obrigado pela atenção e pelo chá. Até logo!",
				"title": "Ethan"
			},
			4: {
				"faceset": "res://assets/nimue/faceset/faceset-nimue.png",
				"dialog": "Até logo, Ethan. Cuide-se!",
				"title": "Nimue"
			}
		}

		Global.dialog_id = 4


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
	$vizinha/AnimatedSprite2D.play("vizinha")
	
	if Input.is_action_just_pressed("dialog") and _player_in_area and not _dialogue_completed and not _dialogue_active:
		$vizinha/Label.hide()
		$vizinho/Label.hide()
		restart_scene()

	if _dialogue_active:
		# Bloqueia todas as ações, exceto "ui_accept"
		var actions = InputMap.get_actions()
		for action in actions:
			if action != "ui_accept" or "pause":
				Input.action_release(action)
	
	if Global.dialog_id == 2 and _dialogue_completed:
		Global.vizinha_animation_state = "vizinho"
		get_tree().change_scene_to_file("res://cenas/HUDs/Day2.tscn")
		
func _ready() -> void:
	var animation_state = Global.vizinha_animation_state

	if animation_state == "vizinho":
		$vizinho.show()
		$vizinha.hide()
	else:
		$vizinha.show()
		$vizinho.hide()



func _on_dialogue_trigger_body_entered(body: Node2D) -> void:
	print("Entrou: ", body.name)
	if body.name == "player":
		_player_in_area = true
		if _dialogue_completed:
			$vizinha/Label.hide()
			$vizinho/Label.hide()
		else:
			$vizinha/Label.show()
			$vizinho/Label.show()

func _on_dialogue_trigger_body_exited(body: Node2D) -> void:
	if body.name == "player":
		$vizinha/Label.hide()
		$vizinho/Label.hide()
		_player_in_area = false

func _on_dialogue_completed():
	_dialogue_completed = true
	_dialogue_active = false  # Libera as ações novamente
	# Atualiza o texto da label no HUD global
	if Global.sucess == 0 and Global.dialog_id == 1:
		$HUD_objetivo/objective_hud.show()
