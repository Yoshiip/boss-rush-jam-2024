extends Control

@onready var music: AudioStreamPlayer = $"../../../Music"
@onready var title: RichTextLabel = $Title

func _ready() -> void:
	visible = true
	title.text = str("[wave]Boss ", GameManager.save_data.level + 1, " [/wave]")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	music.play()
	queue_free()
