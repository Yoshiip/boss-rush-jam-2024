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
	core.new_phase.connect(spawn_wave)
	core.took_damage.connect(_core_took_damage)
	$Canvas/Container/PlayerHealth/ProgressBar.max_value = spaceship.max_health
	$Canvas/Container/PlayerHealth/ProgressBar.value = spaceship.max_health
	$Canvas/Container/PlayerHealth/Value.text = str(spaceship.health, "/", spaceship.max_health)
	
	
	spawn_spikes(5)
	spawn_wave(5)
	
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


func spawn_enemy(enemy_id: String, pos: Vector2) -> void:
	var enemy: PhysicsBody2D
	match enemy_id:
		"default_eye":
			enemy = DEFAULT_EYE.instantiate()
		"spike_ball":
			enemy = SPIKE_BALL.instantiate()
	enemy.global_position = pos
	planet.add_child(enemy)


func spawn_wave(count: int) -> void:
	for pos in _get_random_valid_positions(count):
		var animation := ENEMY_SPAWN_ANIMATION.instantiate()
		animation.position = pos
		animation.done.connect(spawn_enemy.bind("default_eye", pos))
		planet.add_child(animation)


const ENEMY_SPAWN_ANIMATION = preload("res://entities/enemy_spawn_animation/enemy_spawn_animation.tscn")

func _get_random_valid_positions(count: int) -> Array[Vector2]:
	var points: Array[Vector2] = []
	for i in range(count):
		var valid_position := false
		var max_attempts := 50
		var attempt := 0
		var pos := Vector2.ZERO
	
		while not valid_position and attempt < max_attempts:
			attempt += 1
			
			var random_angle = randf() * PI * 2
			var random_distance = randi_range(-150,300)
			pos = Vector2(cos(random_angle), sin(random_angle)) * (planet_radius+random_distance)

			# checks if the position is clear
			if not is_point_colliding(pos):
				valid_position = true
		if valid_position:
			points.append(pos)
	return points

func spawn_spikes(num : float) -> void:
	for pos in _get_random_valid_positions(num):
		var spike = SPIKE_BALL.instantiate()
		spike.position = pos
		planet.add_child(spike)
