extends Node

# since audio files for button are accessed from a lot of same scripts, it better to load it once here.
const UI_SOUNDS = {
	"click": preload("res://audios/effects/ui/selected.wav"),
	"hover": preload("res://audios/effects/ui/hover1.wav")
}

var save_data = {
	"money": 0,
	"level": 0,
	"fire_rate_level": 0,
	"bounce_level": 1,
	"bullet_speed_level": 0,
	"infection_level": 1,
}

func clear_save_data() -> void:
	save_data = {
		"money": 0,
		"level": 0,
		"fire_rate_level": 0,
		"bounce_level": 1,
		"bullet_speed_level": 0,
		"infection_level": 1,
	}

func _ready() -> void:
	clear_save_data()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("fullscreen"):
		get_window().mode = Window.MODE_WINDOWED if get_window().mode == Window.MODE_FULLSCREEN else Window.MODE_FULLSCREEN
