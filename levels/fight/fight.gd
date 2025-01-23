class_name FightRoot
extends Node2D

@export var spin_speed := 0.1
@export var planet_radius := 400.0

@onready var spaceship: Spaceship = $Spaceship
@onready var core: Core = $Core

const PAUSE = preload("res://ui/pause/pause.tscn")
const DEFAULT_EYE = preload("res://entities/eyes/default/default_eye.tscn")
const SPIKE_BALL = preload("res://entities/Damaging Parts/spike_ball.tscn")

const DIALOGUE = preload("res://ui/dialogue/dialogue.tscn")

func _ready() -> void:
	spaceship.allow_inputs.append("start")
	spaceship.took_damage.connect(_player_took_damage)
	spaceship.dead.connect(_on_player_dead)
	core.took_damage.connect(_core_took_damage)
	$Canvas/Container/PlayerHealth/ProgressBar.max_value = spaceship.max_health
	$Canvas/Container/PlayerHealth/ProgressBar.value = spaceship.max_health
	$Canvas/Container/PlayerHealth/Value.text = str(spaceship.health, "/", spaceship.max_health)
	
	#spawn_wave(2,10,5,0,0.35, 0.8)
	
	$Canvas/Container/BossHealth/ProgressBar.max_value = core.max_health
	$Canvas/Container/BossHealth/ProgressBar.value = core.max_health
	
	var pause := PAUSE.instantiate()
	pause.visible = false
	$Canvas/Container.add_child(pause)
	


func transition_ended() -> void:
	spaceship.allow_inputs.erase("start")
	_spawn_dialogue()

func _spawn_dialogue() -> void:
	var dialogue := DIALOGUE.instantiate()
	$Canvas/Container.add_child(dialogue)
	spaceship.allow_inputs.append("dialogue")
	dialogue.ended.connect(func ():
		spaceship.allow_inputs.erase("dialogue")
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	)

func _process(delta: float) -> void:
	$Planet.rotation += delta * spin_speed

func _player_took_damage() -> void:
	$Camera.add_trauma(5.0)
	$Canvas/Container/PlayerHealth/ProgressBar.value = spaceship.health
	$Canvas/Container/PlayerHealth/Value.text = str(spaceship.health, "/", spaceship.max_health)

func _core_took_damage() -> void:
	$Canvas/Container/BossHealth/ProgressBar.value = core.health


func spawn_wave(eye_num : float, hp : float, fire_rate : float, chance :float,  acc : float, speed : float) -> void:
	$Camera.add_trauma(25.0)
	
	for i in eye_num:
		var valid_position = false
		var max_attempts = 50  # prevent infinite loops
		var attempt = 0
		var eye_position = Vector2.ZERO
	
		while not valid_position and attempt < max_attempts:
			attempt += 1
			
			var random_angle = randf() * PI * 2
			var random_distance = randi_range(-350,30)
			eye_position = Vector2(cos(random_angle), sin(random_angle)) * (planet_radius+ random_distance)

			# checks if the position is clear
			if not is_point_colliding(eye_position):
				valid_position = true

		# If a valid position was found, instantiate the eye
		if valid_position:
			var eye = DEFAULT_EYE.instantiate()
			eye.position = eye_position
			if fire_rate>3:
				eye.modulate= Color.RED
			$Planet.add_child(eye)
			eye.max_health = hp
			eye.max_shoot_timer = fire_rate
			eye.special_chance = chance
			eye.accurracy = acc
			eye.bullet_speed = speed
			
		else:
			print("failed to find valid position")
			
func spawn_spikes(num : float) -> void:
	$Camera.add_trauma(25.0)
	
	for i in num:
		var valid_position = false
		var max_attempts = 50  # prevent infinite loops
		var attempt = 0
		var spike_position = Vector2.ZERO
	
		while not valid_position and attempt < max_attempts:
			attempt += 1
			
			var random_angle = randf() * PI * 2
			var random_distance = randi_range(-150,300)
			spike_position = Vector2(cos(random_angle), sin(random_angle)) * (planet_radius+random_distance)

			# checks if the position is clear
			if not is_point_colliding(spike_position):
				valid_position = true

		# If a valid position was found, instantiate the eye
		if valid_position:
			var spike = SPIKE_BALL.instantiate()
			spike.position = spike_position
			$Planet.add_child(spike)
		
			
		else:
			print("failed to find valid position")


func is_point_colliding(point: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query_point = PhysicsPointQueryParameters2D.new()
	var result = space_state.intersect_point(query_point)
	query_point.position = point
	
	if result.size() == 0:
		
		var query = PhysicsShapeQueryParameters2D.new()
		
		var circle_shape = CircleShape2D.new()
		circle_shape.radius = 60 
		query.shape = circle_shape
		query.transform.origin = point
		var result2 = space_state.intersect_shape(query)
		return result2.size() > 0
	return result.size() > 0


func _on_player_dead() -> void:
	get_tree().paused = true
	$Canvas/Container/GameOver.visible = true


const EFFECTS_BUS = &"Effects"

func _get_audio_player(at: Vector2) -> AudioStreamPlayer2D:
	var audio := AudioStreamPlayer2D.new()
	audio.position = at
	audio.bus = EFFECTS_BUS
	return audio;

const PROJECTILE_BOUNCE_SFX = preload("res://audios/effects/bounce.wav")
const PROJECTILE_SHOOT_SFX = preload("res://audios/effects/shoot1.wav")

func spawn_bullet_sfx(at: Vector2) -> void:
	var _audio := _get_audio_player(at)
	_audio.stream = PROJECTILE_SHOOT_SFX
	add_child(_audio)

func spawn_bounce_sfx(at: Vector2) -> void:
	var _audio := _get_audio_player(at)
	_audio.stream = PROJECTILE_BOUNCE_SFX
	add_child(_audio)
