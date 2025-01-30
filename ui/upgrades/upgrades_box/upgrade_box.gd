class_name UpgradeBox
extends Panel

signal added_point
signal removed_point


@export var title: String
@export var max_level := 3
var current_level := 0

func _update_ui() -> void:
	current_level = GameManager.save_data.get(name, -1)
	if current_level == -1:
		title = "Error!"
		return
	
	$Container/Title.text = title
	$Container/Container/Level/Current.text = str(current_level)
	

func _ready() -> void:
	$Container/Container/Level/Max.text = str(max_level)
	_update_ui()
	
	#if arrows:
		#custom_minimum_size.y += 24


func _on_add_button_pressed() -> void:
	if current_level >= max_level: return
	if GameManager.save_data.points <= 0: return
	
	GameManager.save_data[name] += 1
	GameManager.save_data.points -= 1
	
	_update_ui()
	added_point.emit()


func _on_remove_button_pressed() -> void:
	if current_level <= 0: return
	
	GameManager.save_data[name] -= 1
	GameManager.save_data.points += 1
	
	_update_ui()
	removed_point.emit()
