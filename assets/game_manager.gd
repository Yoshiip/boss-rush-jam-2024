extends Node

# since audio files for button are accessed from a lot of same scripts, it better to load it once here.
const UI_SOUNDS = {
	"click": preload("res://audios/effects/ui/selected.wav"),
	"hover": preload("res://audios/effects/ui/hover1.wav")
}

var save_data := {}

func clear_save_data() -> void:
	save_data = {
		"level": 0
	}

func _ready() -> void:
	clear_save_data()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
