extends Control

@export var objective_label: Label = null

func set_objective(text: String) -> void:
	if objective_label:
		objective_label.text = text
