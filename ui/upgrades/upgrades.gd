extends Control
@onready var points_label: Label = $Canvas/Container/Points



func _update_ui() -> void:
	points_label.text = str("tech points: ", GameManager.save_data.points)

func _ready() -> void:
	_update_ui()
	for upgrade in get_tree().get_nodes_in_group("UpgradesBox"):
		upgrade.added_point.connect(_upgrade_added_point)
		upgrade.removed_point.connect(_upgrade_removed_point)


func _upgrade_added_point() -> void:
	_update_ui()
	

func _upgrade_removed_point() -> void:
	_update_ui()
