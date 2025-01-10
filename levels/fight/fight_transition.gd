extends Control

@onready var music: AudioStreamPlayer = $"../../../Music"

func _ready() -> void:
	visible = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	music.play()
	queue_free()
