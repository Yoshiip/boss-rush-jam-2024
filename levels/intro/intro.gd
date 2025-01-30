extends Node2D

const DIALOGUE = preload("res://ui/dialogue/dialogue.tscn")

func _ready() -> void:
	var tween := get_tree().create_tween()
	$Canvas/Container/Date.modulate.a = 0.0
	tween.tween_property($Canvas/Container/Date, "modulate:a", 1.0, 2.0)
	tween.tween_interval(2.0)
	tween.tween_property($Canvas/Container/Date, "modulate:a", 0.0, 1.0)
	tween.tween_callback(_start_dialogue)
	
func _start_dialogue() -> void:
	var dialogue = DIALOGUE.instantiate()
	dialogue.ended.connect(_on_dialogue_ended)
	dialogue.event.connect(_on_dialogue_event)
	dialogue.dialogue = GameDialogues.INTRO_DIALOGUE
	$Canvas/Container.add_child(dialogue)
	

func _on_dialogue_event(id: String) -> void:
	match id:
		"ship":
			$Spaceship.visible = true

func _on_dialogue_ended() -> void:
	get_tree().change_scene_to_file("res://levels/upgrades/upgrades.tscn")
	
