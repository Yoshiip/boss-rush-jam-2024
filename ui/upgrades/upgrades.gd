extends Control

@onready var points_label: Label = $Canvas/Container/Footer/Points
@onready var description: Label = $Canvas/Container/Footer/Description

func _update_ui() -> void:
	points_label.text = str("points: ", GameManager.save_data.points)

func _ready() -> void:
	_update_ui()
	for upgrade in get_tree().get_nodes_in_group("UpgradesBox"):
		upgrade.added_point.connect(_upgrade_added_point)
		upgrade.removed_point.connect(_upgrade_removed_point)
		upgrade.mouse_entered.connect(_upgrade_mouse_entered.bind(upgrade))
		upgrade.mouse_exited.connect(_upgrade_mouse_exited.bind(upgrade))
	
	UiUtils.apply_transition($Canvas/Container/Boxes)
	UiUtils.apply_transition($Canvas/Container/Boxes/Top)
	UiUtils.apply_transition($Canvas/Container/Boxes/Bottom/Left)
	UiUtils.apply_transition($Canvas/Container/Boxes/Bottom/Right)
	UiUtils.apply_transition($Canvas/Container/Footer)
	#After playing through the game multiple times, I think the upgrades need to be available from the begining
	#$Canvas/Container/Boxes/Bottom/Left.visible = GameManager.save_data.level >= 0
	#$Canvas/Container/Boxes/Bottom/Right.visible = GameManager.save_data.level >= 0

func _upgrade_mouse_entered(upgrade: Panel) -> void:
	description.text = upgrade.description

func _upgrade_mouse_exited(_upgrade: Panel) -> void:
	description.text = ""

func _upgrade_added_point(new_level: int, max_level: int) -> void:
	_update_ui()
	$Upgrade.pitch_scale = 1.0 + float(new_level) / float(max_level)
	$Upgrade.play()
	

func _upgrade_removed_point() -> void:
	_update_ui()
	$Upgrade.pitch_scale = 1.0
	$Upgrade.play()


func _on_continue_pressed() -> void:
	GameManager.go_to_fight()
