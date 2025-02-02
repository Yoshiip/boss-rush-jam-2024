extends Node

# since audio files for button are accessed from a lot of same scripts, it better to load it once here.
const UI_SOUNDS = {
	"click": preload("res://audios/effects/ui/selected.wav"),
	"hover": preload("res://audios/effects/ui/hover1.wav")
}

var save_data = {
		"points": 5,
		"level": 0,
		
		# UPGRADES
		"hull_health": 1,
		"fire_rate": 1,
		"thrusters": 1,
		"bullet_size": 0,
		"bullet_speed": 1,	
		# BOUNCES UPGRADES
		"bounce": 0,
		"damage_on_bounce": 0,
		"split": 0,
		
		# DEFLECT UPGRADES
		"deflection": 0,
		"pierce": 0,
		"infection" : 0,
	}
func clear_save_data() -> void:
	save_data = {
		"points": 5,
		"level": 0,
		
		# UPGRADES
		"hull_health": 1,
		"fire_rate": 1,
		"thrusters": 1,
		"bullet_size": 1,
		"bullet_speed": 1,	
		# BOUNCES UPGRADES
		"bounce": 0,
		"damage_on_bounce": 0,
		"split": 0,
		
		# DEFLECT UPGRADES
		"deflection": 0,
		"pierce": 0,
		"infection" : 0,
	}

# functions to return the max of each levels

const BULLETS_SIZE := [0.75,1.0, 1.5,1.75, 2.0]
const BULLETS_SPEED := [3.0,6.0,9.0,12.0, 15.0]

func get_health() -> int:
	return 4 + GameManager.save_data.hull_health * 3

func get_deflect() -> int:
	return GameManager.save_data.deflection_bullet

func get_bullet_size() -> float:
	return BULLETS_SIZE[GameManager.save_data.bullet_size]

func get_bullet_speed() -> float:
	return BULLETS_SPEED[GameManager.save_data.bullet_speed]

func get_splits() -> int:
	return GameManager.save_data.split

func get_bounces() -> int:
	return GameManager.save_data.bounce

func get_damage_up_bounces() -> int:
	return GameManager.save_data.damage_on_bounce


func get_pierces() -> int:
	return GameManager.save_data.pierce

func get_infection_bullet() -> int:
	return GameManager.save_data.infection

func get_deflection() -> int:
	return GameManager.save_data.deflection



func _ready() -> void:
	clear_save_data()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		get_window().mode = Window.MODE_WINDOWED if get_window().mode == Window.MODE_FULLSCREEN else Window.MODE_FULLSCREEN

func go_to_fight() -> void:
	match save_data.level:
		0:
			get_tree().change_scene_to_file("res://levels/fights/terrain intro/terrain_intro.tscn")
		1:
			get_tree().change_scene_to_file("res://levels/fights/small_enemy_intro/small_enemy_intro.tscn")
		2:
			get_tree().change_scene_to_file("res://levels/fights/first/first_fight.tscn")
		3:
			get_tree().change_scene_to_file("res://levels/fights/void/void_fight.tscn")
		4:
			get_tree().change_scene_to_file("res://levels/fights/steampunk/steampunk_fight.tscn")
		_:
			get_tree().change_scene_to_file("res://levels/victory/victory.tscn")
