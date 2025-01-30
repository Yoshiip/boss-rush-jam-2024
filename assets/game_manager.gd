extends Node

# since audio files for button are accessed from a lot of same scripts, it better to load it once here.
const UI_SOUNDS = {
	"click": preload("res://audios/effects/ui/selected.wav"),
	"hover": preload("res://audios/effects/ui/hover1.wav")
}

var save_data = {
	"money": 0,
	"level": 0,
	"hull health": 10,
	"fire_rate_level": 0,
	"deflection_bullet": true,
	"bounce_level": 4,
	"split_bounce_level":0,
	"bullet_speed_level": 0,
	"infection_level": 0,
	"pierce_level": 0, 
	"bullet_size" :1 
}

func clear_save_data() -> void:
	save_data = {
		"money": 0,
		"level": 0,
		"hull health": 10,
		"fire_rate_level": 0,
		"deflection_bullet": true,
		"bounce_level": 2,
		"bullet_speed_level": 0,
		"split_bounce_level":0,
		"infection_level": 0,
		"pierce_level" : 0,
		"bullet_size" :1 
	}

func _ready() -> void:
	clear_save_data()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("fullscreen"):
		get_window().mode = Window.MODE_WINDOWED if get_window().mode == Window.MODE_FULLSCREEN else Window.MODE_FULLSCREEN
