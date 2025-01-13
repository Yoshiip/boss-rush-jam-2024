extends Node2D

@export var spin_speed := 0.1
@export var planet_radius := 400.0

@onready var spaceship: Spaceship = $Spaceship
@onready var core: Core = $Core
const PAUSE = preload("res://ui/pause/pause.tscn")
func _ready() -> void:
	spaceship.took_damage.connect(_player_took_damage)
	spaceship.dead.connect(_on_player_dead)
	core.took_damage.connect(_core_took_damage)
	$Canvas/Container/PlayerHealth/ProgressBar.max_value = spaceship.max_health
	$Canvas/Container/PlayerHealth/ProgressBar.value = spaceship.max_health
	$Canvas/Container/PlayerHealth/Value.text = str(spaceship.health, "/", spaceship.max_health)
	
	spawn_wave(4,10,2,0,0.35, 0.8)
	
	$Canvas/Container/BossHealth/ProgressBar.max_value = core.max_health
	$Canvas/Container/BossHealth/ProgressBar.value = core.max_health
	
	var pause := PAUSE.instantiate()
	pause.visible = false
	$Canvas/Container.add_child(pause)


func _process(delta: float) -> void:
	$Planet.rotation += delta * spin_speed

func _player_took_damage() -> void:
	$Camera.add_trauma(5.0)
	$Canvas/Container/PlayerHealth/ProgressBar.value = spaceship.health
	$Canvas/Container/PlayerHealth/Value.text = str(spaceship.health, "/", spaceship.max_health)

func _core_took_damage() -> void:
	$Canvas/Container/BossHealth/ProgressBar.value = core.health

const DEFAULT_EYE = preload("res://entities/eyes/default/default_eye.tscn")

func spawn_wave(eye_num : int, hp : int, shoot_time : float, special :float,  acurracy : float, bullet_speed : float) -> void:
	$Camera.add_trauma(25.0)

	for i in eye_num:
		var valid_position = false
		var max_attempts = 50  # prevent infinite loops
		var attempt = 0
		var eye_position = Vector2.ZERO
	
		while not valid_position and attempt < max_attempts:
			attempt += 1
			
			var random_angle = randf() * PI * 2
			eye_position = Vector2(cos(random_angle), sin(random_angle)) * planet_radius

			# checks if the position is clear
			if not is_point_colliding(eye_position):
				valid_position = true

		# If a valid position was found, instantiate the eye
		if valid_position:
			var eye = DEFAULT_EYE.instantiate()
			eye.position = eye_position
			$Planet.add_child(eye)
			eye.max_health = hp
			eye.max_shoot_timer = shoot_time
			eye.special_chance = special
			eye.accurracy = acurracy
			eye.bullet_speed = bullet_speed
			
		else:
			print("failed to find valid position")

func is_point_colliding(point: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = point
	var result = space_state.intersect_point(query)
	return result.size() > 0
	
func _on_player_dead() -> void:
	get_tree().paused = true
	$Canvas/Container/GameOver.visible = true
