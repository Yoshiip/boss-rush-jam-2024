extends Node2D

const DIALOGUE = preload("res://ui/dialogue/dialogue.tscn")

func _ready() -> void:
	var tween := get_tree().create_tween()
	$Canvas/Container/Date.modulate.a = 0.0
	tween.tween_property($Canvas/Container/Date, "modulate:a", 1.0, 2.0)
	tween.tween_interval(2.0)
	tween.tween_property($Canvas/Container/Date, "modulate:a", 0.0, 1.0)
	tween.tween_callback(_start_dialogue)

const PHONE_TEXTURE = preload("res://ui/dialogue/portraits/phone.jpg")

func _start_dialogue() -> void:
	var dialogue = DIALOGUE.instantiate()
	dialogue.ended.connect(_on_dialogue_ended)
	dialogue.event.connect(_on_dialogue_event)
	dialogue.dialogue = GameDialogues.INTRO_DIALOGUE
	dialogue.set_other("Phone", PHONE_TEXTURE)
	$Canvas/Container.add_child(dialogue)
func _on_dialogue_event(id: String) -> void:
	match id:
		"ship":
			$Canvas/Container/Spaceship.visible = true
			$Canvas/Container/Spaceship.modulate.a = 0.0
			var tween := get_tree().create_tween()
			tween.tween_property($Canvas/Container/Spaceship, "modulate:a", 1.0, 0.5)

func _on_dialogue_ended() -> void:
	get_tree().change_scene_to_file("res://levels/upgrades/upgrades.tscn")
	


func _on_skip_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/upgrades/upgrades.tscn")
