extends VBoxContainer

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if get_tree().paused && event.is_action_pressed("fire"):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://levels/menu/menu.tscn")
