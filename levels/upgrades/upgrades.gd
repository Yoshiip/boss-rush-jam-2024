extends Control


func _ready() -> void:
	pass


func _on_button_pressed() -> void:
	GameManager.save_data.level += 1;
	get_tree().change_scene_to_file("res://levels/fight/fight.tscn")
