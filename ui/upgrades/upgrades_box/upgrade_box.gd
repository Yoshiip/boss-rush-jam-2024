class_name UpgradeBox
extends Panel

signal added_point(new_level: int, max_level: int)
signal removed_point


@export var title: String
@export_multiline var description: String
@export var max_level := 3

@export var constraint := ""
var constraint_node: Panel

var current_level := 0

func _update_ui() -> void:
	current_level = GameManager.save_data.get(name, -1)
	if current_level == -1:
		title = "Error!"
		return
	
	$Container/Title.text = title
	$Container/Container/Level/Current.text = str(current_level)
	$Container/Container/Level/Max.text = str(max_level)
	$Max.visible = current_level != 0 && current_level >= max_level
	$Container/Container/RemoveButton.visible = max_level != 0
	$Container/Container/AddButton.visible = max_level != 0
	modulate.a = 0.5 if max_level == 0 else 1.0
	

func _ready() -> void:
	_update_ui()
	
	if constraint != "":
		for node in get_tree().get_nodes_in_group("UpgradesBox"):
			if node.name == constraint:
				constraint_node = node
				constraint_node.added_point.connect(func(_new_level, _max_level):
					_on_constraint_changed()
				)
				constraint_node.removed_point.connect(_on_constraint_changed)
				_on_constraint_changed()

func _on_constraint_changed() -> void:
	max_level = constraint_node.current_level
	print(max_level)
	if current_level > max_level:
		_on_remove_button_pressed()
	_update_ui()
	#if arrows:
		#custom_minimum_size.y += 24


func _on_add_button_pressed() -> void:
	if current_level >= max_level: return
	if GameManager.save_data.points <= 0: return
	
	GameManager.save_data[name] += 1
	GameManager.save_data.points -= 1
	
	_update_ui()
	added_point.emit(current_level, max_level)


func _on_remove_button_pressed() -> void:
	if current_level <= 0: return
	
	GameManager.save_data[name] -= 1
	GameManager.save_data.points += 1
	
	_update_ui()
	removed_point.emit()
