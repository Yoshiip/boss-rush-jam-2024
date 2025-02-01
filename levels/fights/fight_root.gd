class_name FightRoot
extends Node2D

@export var planet_radius := 400.0
@export var boss: BossInfo
@export var spin_speed := 0.1

@onready var spaceship: Spaceship = $Spaceship
@onready var planet := $Planet


const CORE = preload("res://entities/core/core.tscn")
var core: Core


# Enemies
const ENEMY_SPAWN_ANIMATION = preload("res://entities/enemy_spawn_animation/enemy_spawn_animation.tscn")


const PAUSE = preload("res://ui/pause/pause.tscn")
const GAME_CANVAS = preload("res://ui/game_canvas.tscn")
const PARALLAX_BACKGROUND = preload("res://assets/backgrounds/parallax_background.tscn")

const EFFECTS_BUS = &"Effects"

var background_sprite: Sprite2D



var canvas: CanvasLayer
var crossfade: Crossfade

func _add_core() -> void:
	core = CORE.instantiate()
	core.stats = boss
	core.positions = $Planet/BossPositions
	add_child(core)

func _ready() -> void:
	
	_add_core()
	
	spaceship.allow_inputs.append("start")
	spaceship.took_damage.connect(_player_took_damage)
	spaceship.dead.connect(_on_player_dead)
	
	canvas = GAME_CANVAS.instantiate()
	add_child(canvas)
	
	canvas.get_node("Container/PlayerHealth/ProgressBar").max_value = spaceship.max_health
	canvas.get_node("Container/PlayerHealth/ProgressBar").value = spaceship.max_health
	canvas.get_node("Container/PlayerHealth/Text/Value").text = str(spaceship.health, "/", spaceship.max_health)
	canvas.get_node("Container/Transition/Title").text = boss.name
	crossfade = Crossfade.new()
	crossfade.a_stream = boss.music
	crossfade.b_stream = boss.pause_music
	crossfade.db = boss.music_db
	add_child(crossfade)
	
	if boss.background != null:
		var background = PARALLAX_BACKGROUND.instantiate()
		
		background_sprite = background.get_node("ParallaxLayer/Sprite")
		background_sprite.texture = boss.background
		add_child(background)
	
	core = get_node("Core")
	core.dead.connect(_on_core_dead)
	core.new_phase.connect(_on_core_new_phase)
	core.health_changed.connect(_on_core_health_changed)
	
	
	

	
	canvas.get_node("Container/BossHealth/ProgressBar").max_value = core.max_health
	
	_on_core_health_changed()
	
	var pause := PAUSE.instantiate()
	pause.crossfade = crossfade
	pause.visible = false
	canvas.get_node("Container").add_child(pause)


func _process(delta: float) -> void:
	background_sprite.position += Vector2.ONE * delta * 4.0
	if background_sprite.position.x > 512:
		background_sprite.position -= Vector2.ONE * 512

func _on_core_new_phase(_index: int) -> void:
	pass

func _on_core_health_changed() -> void:
	canvas.get_node("Container/BossHealth/ProgressBar").value = core.health
	canvas.get_node("Container/BossHealth/Text/Value").text = str(floor(core.health * 100.0 / core.max_health), "%")

func _on_core_dead() -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://levels/cutscene/cutscene.tscn")

func transition_ended() -> void:
	crossfade.start_a()
	spaceship.allow_inputs.erase("start")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _player_took_damage() -> void:
	$Camera.add_trauma(5.0)
	canvas.get_node("Container/PlayerHealth/ProgressBar").value = max(spaceship.health, 0)
	canvas.get_node("Container/PlayerHealth/Text/Value").text = str(spaceship.health, "/", spaceship.max_health)


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
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	crossfade.stop_both()
	canvas.get_node("Container/GameOver").start()



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

const BULLET_PARTICLES = preload("res://assets/bullets/bullet_particles.tscn")

func spawn_bullet_destroy_particles(at: Vector2, from_enemy: bool) -> void:
	var particles := BULLET_PARTICLES.instantiate()
	particles.position = at
	particles.from_enemy = from_enemy
	add_child(particles)

func _get_random_valid_positions(count: int) -> Array[Vector2]:
	var points: Array[Vector2] = []
	for node in get_tree().get_nodes_in_group("EnemySpawnpoint"):
		if !is_point_colliding(node.global_position):
			points.append(node.global_position)
	if points.is_empty():
		return _get_pure_random_points(count)
	points.shuffle()
	
	return points.slice(0, count)


func _get_pure_random_points(count: int) -> Array[Vector2]:
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
