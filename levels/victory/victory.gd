extends Control

const DIALOGUE = preload("res://ui/dialogue/dialogue.tscn")

var dialogue: Dialogue
func _on_dialogue_event(id: String) -> void:
	dialogue.set_other("Chief", MAN_TEXTURE)

const MAN_TEXTURE = preload("res://ui/dialogue/portraits/man.jpg")

func _ready() -> void:
	$Canvas/Container/Container.visible = false
	dialogue = DIALOGUE.instantiate()
	var dial: Array[String]
	dial.assign(GameDialogues.MISSIONS[4])
	dialogue.dialogue = dial
	dialogue.ended.connect(_on_dialogue_ended)
	dialogue.event.connect(_on_dialogue_event)
	
	$Canvas/Container.add_child(dialogue)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_dialogue_ended() -> void:
	$Music.play()
	$Canvas/Container/Container.visible = true
	UiUtils.apply_transition($Canvas/Container/Container)
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/menu/menu.tscn")
