class_name FightBossRoot
extends FightRoot


@export var spin_speed := 0.1
@export var planet_radius := 400.0

var core: Core

const DEFAULT_EYE = preload("res://entities/eyes/default/default_eye.tscn")
const SPIKE_BALL = preload("res://entities/Damaging Parts/spike_ball.tscn")


@onready var planet := $Planet

func _ready() -> void:
	super()
	core = get_node("Core")
	core.dead.connect(_on_core_dead)
	core.took_damage.connect(_core_took_damage)
	$Canvas/Container/PlayerHealth/ProgressBar.max_value = spaceship.max_health
	$Canvas/Container/PlayerHealth/ProgressBar.value = spaceship.max_health
	$Canvas/Container/PlayerHealth/Value.text = str(spaceship.health, "/", spaceship.max_health)
	
	spawn_wave(2,10,5,0,0.35, 0.8)
	
	$Canvas/Container/BossHealth/ProgressBar.max_value = core.max_health
	$Canvas/Container/BossHealth/ProgressBar.value = core.max_health
	
	var pause := PAUSE.instantiate()
	pause.visible = false
	$Canvas/Container.add_child(pause)
	


@onready var background_sprite: Sprite2D = $ParallaxBackground/ParallaxLayer/BackgroundSprite

func _process(delta: float) -> void:
	planet.rotation += delta * spin_speed
	
	background_sprite.position += Vector2.ONE * delta * 4.0
	if background_sprite.position.x > 512:
		background_sprite.position -= Vector2.ONE * 512


func _core_took_damage() -> void:
	$Canvas/Container/BossHealth/ProgressBar.value = core.health

func _on_core_dead() -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://levels/cutscene/cutscene.tscn")

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
			planet.add_child(eye)
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
			planet.add_child(spike)
		
			
		else:
			print("failed to find valid position")
