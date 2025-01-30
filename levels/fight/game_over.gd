extends VBoxContainer

func start() -> void:
	visible = true
	$AnimationPlayer.play("GameOver")

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$Restart.visible = true
