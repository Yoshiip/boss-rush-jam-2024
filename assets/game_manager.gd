extends Node

# since audio files for button are accessed from a lot of same scripts, it better to load it once here.
const UI_SOUNDS = {
	"click": preload("res://audios/effects/ui/selected.wav"),
	"hover": preload("res://audios/effects/ui/hover1.wav")
}

var save_data = {
	"points": 10,
	"level": 0,
	
	# UPGRADES
	"hull_health": 0,
	"fire_rate": 0,
	"thrusters": 0,
	"bullet_size": 0,
	
	# BOUNCES UPGRADES
	"bullet_bounce": 0,
	"damage_on_bounce": 0,
	"split_on_bounce": 0,
	
	# SPECIAL BULLETS
	"deflection_bullet": 0,
	"bullet_pierce": 0,
	"infection_bullet" : 0,
}

func clear_save_data() -> void:
	save_data = {
		"points": 10,
		"level": 1,
		
		# UPGRADES
		"hull_health": 0,
		"fire_rate": 0,
		"thrusters": 0,
		"bullet_size": 0,
		
		# BOUNCES UPGRADES
		"bullet_bounce": 0,
		"damage_on_bounce": 0,
		"split_on_bounce": 0,
		
		# SPECIAL BULLETS
		"deflection_bullet": 0,
		"bullet_pierce": 0,
		"infection_bullet" : 0,
	}

# functions to return the max of each levels

const BULLETS_SIZE := [1.0, 1.2, 1.4, 1.6, 1.8, 2.0]

func get_health() -> int:
	return 10 + GameManager.save_data.hull_health * 2

func is_deflect() -> bool:
	return GameManager.save_data.deflection_bullet

func get_bullet_size() -> float:
	return BULLETS_SIZE[GameManager.save_data.bullet_size]

func get_splits() -> int:
	return GameManager.save_data.split_on_bounce

func get_bounces() -> int:
	return GameManager.save_data.bullet_bounce + 2

func get_pierces() -> int:
	return GameManager.save_data.bullet_pierce

func get_infection_bullet() -> int:
	return GameManager.save_data.infection_bullet

func get_deflection() -> int:
	return GameManager.save_data.deflection



func _ready() -> void:
	clear_save_data()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("fullscreen"):
		get_window().mode = Window.MODE_WINDOWED if get_window().mode == Window.MODE_FULLSCREEN else Window.MODE_FULLSCREEN
