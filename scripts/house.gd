extends Node2D
class_name Level

#mudar a imagem do personagem -> faceset
#mudar dialogo -> dialog
#mudar nome do personagem -> title

const _DIALOG_SCREEN: PackedScene = preload("res://cenas/dialogue_screen.tscn")

var _player_in_area: bool = false
var _dialogue_completed: bool = false

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://icon.svg",
		"dialog": "Ah, olá! Você deve ser minha vizinha.",
		"title": "Nimue"
	},
	
	1: {
		"faceset": "res://icon.svg",
		"dialog": "Isso mesmo! Sou Kaitlyn, moro na casa ao lado. Queria dar as boas-vindas. Vi que você se mudou há poucos dias e pensei em passar aqui.",
		"title": "Kaitlyn"
	},
	2: {
		"faceset": "res://icon.svg",
		"dialog": "Muito obrigada, Kaitlyn! Eu sou a Nimue. Estou tentando arrumar as coisas, mas é tanta bagunça... (risos) Quer entrar?",
		"title": "Nimue"
	},
	3: {
		"faceset": "res://icon.svg",
		"dialog": "Claro, obrigada! (entra e observa as caixas espalhadas) Mudanças são sempre assim, né? Um caos no começo, mas depois tudo se ajeita.",
		"title": "Kaitlyn"
	},
	4: {
		"faceset": "res://icon.svg",
		"dialog": "Exatamente. Ainda estou tentando lembrar onde coloquei metade das minhas coisas. Mas me conta, está tudo bem com você? Você parece um pouco cansada...",
		"title": "Nimue"
	},
	5: {
		"faceset": "res://icon.svg",
		"dialog": "Ah, você percebeu? (sorri meio sem graça) Pois é, meu trabalho tem me consumido. Estou em um projeto enorme, e tem sido noites e noites mal dormidas.",
		"title": "Kaitlyn"
	},
	6: {
		"faceset": "res://icon.svg",
		"dialog": "Nossa, imagino o quanto deve ser puxado... Não é fácil lidar com a falta de sono.",
		"title": "Nimue"
	},
	7: {
		"faceset": "res://icon.svg",
		"dialog": "Não mesmo. Eu até tento desligar a mente antes de dormir, mas às vezes parece impossível.",
		"title": "Kaitlyn"
	},
	8: {
		"faceset": "res://icon.svg",
		"dialog": "Sabe, acho que posso ajudar. Eu tinha um chá relaxante incrível que costumava usar nessas situações. Ele me ajudava a dormir como uma pedra. Só preciso lembrar em qual dessas caixas ele está...",
		"title": "Nimue"
	},
	9: {
		"faceset": "res://icon.svg",
		"dialog": "(rindo) Não se preocupe, não quero te dar mais trabalho no meio dessa bagunça!",
		"title": "Kaitlyn"
	},
	10: {
		"faceset": "res://icon.svg",
		"dialog": "Imagina! Vai ser uma desculpa para eu tentar organizar essas caixas mais rápido. Vou dar uma procurada depois e te levo, pode ser?",
		"title": "Nimue"
	},
	11: {
		"faceset": "res://icon.svg",
		"dialog": "Poxa, Nimue, muito obrigada. Seria ótimo!",
		"title": "Kaitlyn"
	},
	12: {
		"faceset": "res://icon.svg",
		"dialog": "Não precisa agradecer. Somos vizinhas, não é? Acho que temos que nos ajudar.",
		"title": "Nimue"
	},
	13: {
		"faceset": "res://icon.svg",
		"dialog": "Com certeza! E se precisar de algo também, pode contar comigo.",
		"title": "Kaitlyn"
	},
	14: {
		"faceset": "res://icon.svg",
		"dialog": "Combinado! E quem sabe um dia você vem tomar um café comigo quando tudo aqui estiver mais em ordem.",
		"title": "Nimue"
	},
	15: {
		"faceset": "res://icon.svg",
		"dialog": "Vou adorar!",
		"title": "Kaitlyn"
	}
}

@export_category("Objects")
@export var _hud: CanvasLayer = null

var _current_dialogue: DialogueScreen = null

func restart_scene():
	if _current_dialogue:
		_current_dialogue.queue_free()
	
	_current_dialogue = _DIALOG_SCREEN.instantiate() as DialogueScreen
	_current_dialogue.data = _dialog_data
	_hud.add_child(_current_dialogue)
	_current_dialogue.reset_dialogue()

	_current_dialogue.connect("tree_exited", Callable(self, "_on_dialogue_completed"))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("dialog") and _player_in_area and not _dialogue_completed:
		$vizinha/Label.hide()
		restart_scene()

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

func _on_dialogue_completed():
	_dialogue_completed = true
	# Atualiza o texto da label no HUD global
	$player/objective_hud/mission_text.show()
	$vizinha.hide()
