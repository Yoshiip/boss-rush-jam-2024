extends Control
@onready var points_label: Label = $Canvas/Container/Boxes/Footer/Points



func _update_ui() -> void:
	points_label.text = str("research points: ", GameManager.save_data.points)

func _ready() -> void:
	_update_ui()
	for upgrade in get_tree().get_nodes_in_group("UpgradesBox"):
		upgrade.added_point.connect(_upgrade_added_point)
		upgrade.removed_point.connect(_upgrade_removed_point)


func _upgrade_added_point(new_level: int, max_level: int) -> void:
	_update_ui()
	$Upgrade.pitch_scale = 1.0 + float(new_level) / float(max_level)
	$Upgrade.play()
	

func _upgrade_removed_point() -> void:
	_update_ui()
	$Upgrade.pitch_scale = 1.0
	$Upgrade.play()


func _on_continue_pressed() -> void:
	GameManager.save_data.level += 1
	get_tree().change_scene_to_file("res://levels/fight/fight.tscn")
