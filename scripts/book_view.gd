extends Node2D

var mensagem = preload("res://assets/witch-face-profile.webp")
var chamomile = preload("res://assets/plants/chamomile_book.png")
var hibiscus = preload("res://assets/plants/hibiscus_book.png")
var gengibre = preload("res://assets/plants/ginger_book.png")


var flowers
var info = [
	["", Flowers.descriptions["Mensagem"]],
	["Camomila", Flowers.descriptions["Chamomile"]],
	["Hibisco", Flowers.descriptions["Hibiscus"]],
	["Gengibre", Flowers.descriptions["Gengibre"]]
]
var closing = false
var open = false
var index = 0

func _ready() -> void:
	visible = false
	flowers = [
		 mensagem, chamomile, hibiscus, gengibre
	]

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("show_book"):
		if not open:
			appear()
			$"..".SPEED=0
		else:
			_on_fechar_pressed()
			$"..".SPEED=100

func resize_flower():
	var panel_size = $Panel.get_size()  # Obtém tamanho do painel
	var texture_size = $Panel/flower.texture.get_size()  # Obtém tamanho da textura
	var scale_factor = min(panel_size.x / texture_size.x, panel_size.y / texture_size.y) * 7.5
	$Panel/flower.scale = Vector2(scale_factor, scale_factor)

func showInfo(index):
	$Panel/flower.texture = flowers[index]
	resize_flower()
	$Panel/name.text = info[index][0]
	$Panel/description.text = info[index][1]
	$Panel/anim.play("appear")

func appear():
	if not open:
		open = true
		closing = false
		visible = true
		$Sprites.play("open")
		$anim_main.play("appear_book")

func _on_sprites_animation_finished() -> void:
	if not closing:
		showInfo(index)

func _on_anim_main_animation_finished(anim_name: StringName) -> void:
	if anim_name == "close_book":
		open = false

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		$Buttons/effect.play()
		$Sprites.play("next")
	elif anim_name == "fade_back":
		$Buttons/effect.play()
		$Sprites.play("previous")
	elif anim_name == "fade_out":
		closing = true
		$effect.play()
		$Sprites.play("close")
		$anim_main.play("close_book")

func _on_next_pressed() -> void:
	if index < len(flowers) - 1:
		index += 1
		$Panel/anim.play("fade")

func _on_prev_pressed() -> void:
	if index > 0:
		index -= 1
		$Panel/anim.play("fade_back")

func _on_fechar_pressed() -> void:
	$Panel/anim.play("fade_out")
