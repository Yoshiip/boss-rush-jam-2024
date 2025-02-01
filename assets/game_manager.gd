extends Node

# since audio files for button are accessed from a lot of same scripts, it better to load it once here.
const UI_SOUNDS = {
	"click": preload("res://audios/effects/ui/selected.wav"),
	"hover": preload("res://audios/effects/ui/hover1.wav")
}

var save_data = {
	"points": 6,
	"level": 0,
	
	# UPGRADES
	"hull_health": 1,
	"fire_rate": 1,
	"thrusters": 1,
	"bullet_size": 0,
	"bullet_speed": 1,
	# BOUNCES UPGRADES
	"bullet_bounce": 0,
	"damage_on_bounce": 0,
	"split_on_bounce": 0,
	
	# DEFLECT UPGRADES
	"deflection_bullet": 0,
	"pierce_bullet": 0,
	"infection_bullet" : 0,
}

func clear_save_data() -> void:
	save_data = {
	"points": 6,
	"level": 0,
	
	# UPGRADES
	"hull_health": 1,
	"fire_rate": 1,
	"thrusters": 1,
	"bullet_size": 0,
	"bullet_speed": 1,	
	# BOUNCES UPGRADES
	"bullet_bounce": 0,
	"damage_on_bounce": 0,
	"split_on_bounce": 0,
	
	# DEFLECT UPGRADES
	"deflection_bullet": 0,
	"pierce_bullet": 0,
	"infection_bullet" : 0,
	}

# functions to return the max of each levels

const BULLETS_SIZE := [1.0, 1.25, 1.5, 1.75, 2.0]
const BULLETS_SPEED := [5.0,7.0,10.0,13.0,15.0]

func get_health() -> int:
	return 4 + GameManager.save_data.hull_health * 3

func get_deflect() -> int:
	return GameManager.save_data.deflection_bullet

func get_bullet_size() -> float:
	return BULLETS_SIZE[GameManager.save_data.bullet_size]

func get_bullet_speed() -> float:
	return BULLETS_SPEED[GameManager.save_data.bullet_speed]

func get_splits() -> int:
	return GameManager.save_data.split_on_bounce

func get_bounces() -> int:
	return GameManager.save_data.bullet_bounce
func get_damage_up_bounces() -> int:
	return GameManager.save_data.damage_on_bounce


func get_pierces() -> int:
	return GameManager.save_data.pierce_bullet

func get_infection_bullet() -> int:
	return GameManager.save_data.infection_bullet

func get_deflection() -> int:
	return GameManager.save_data.deflection_bullet



func _ready() -> void:
	clear_save_data()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("fullscreen"):
		get_window().mode = Window.MODE_WINDOWED if get_window().mode == Window.MODE_FULLSCREEN else Window.MODE_FULLSCREEN
