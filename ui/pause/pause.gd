extends ColorRect

const SETTINGS_MENU = preload("res://ui/settings/settings_menu.tscn")

var crossfade: Crossfade

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle()

func toggle() -> void:
	visible = !visible
	get_tree().paused = visible
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if is_instance_valid(crossfade): crossfade.to_b()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		if is_instance_valid(crossfade): crossfade.to_a()


func _on_continue_button_pressed() -> void:
	toggle()



func _on_settings_button_pressed() -> void:
	var settings := SETTINGS_MENU.instantiate()
	add_child(settings)

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://levels/menu/menu.tscn")


func _on_changespaceship_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://levels/upgrades/upgrades.tscn")
