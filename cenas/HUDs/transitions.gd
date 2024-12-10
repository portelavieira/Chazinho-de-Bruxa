extends Control

func change_scene_to_file(target: String) -> void:
	$AnimationPlayer.play("fade-in")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("fade-in")
