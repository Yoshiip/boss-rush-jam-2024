extends ColorRect

const SETTINGS_MENU = preload("res://ui/settings/settings_menu.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		visible = !visible
		print(visible)
		get_tree().paused = visible

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	


func _on_settings_button_pressed() -> void:
	var settings := SETTINGS_MENU.instantiate()
	add_child(settings)

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://levels/menu/menu.tscn")
