extends VBoxContainer

func start() -> void:
	visible = true
	$AnimationPlayer.play("GameOver")
	$Buttons.visible = false

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	$Buttons.visible = true


func _on_upgrades_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://levels/upgrades/upgrades.tscn")
