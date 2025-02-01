class_name FightRoot
extends Node2D

@export var planet_radius := 400.0
@export var boss: BossInfo
@export var spin_speed := 0.1

@onready var spaceship: Spaceship = $Spaceship
@onready var planet := $Planet

const ENEMIES_TYPE := ["default_eye", "laser_eye", "spike_ball", "bomber"]

const CORE = preload("res://entities/core/core.tscn")
var core: Core



# Enemies
const DEFAULT_EYE = preload("res://entities/eyes/default/default_eye.tscn")
const BOMBER = preload("res://entities/bomber/bomber.tscn")
const SPIKE_BALL = preload("res://entities/Damaging Parts/spike_ball.tscn")
const LASER_EYE = preload("res://entities/eyes/laser_eye/laser_eye.tscn")
const ENEMY_SPAWN_ANIMATION = preload("res://entities/enemy_spawn_animation/enemy_spawn_animation.tscn")



const PAUSE = preload("res://ui/pause/pause.tscn")
const GAME_CANVAS = preload("res://ui/game_canvas.tscn")
const PARALLAX_BACKGROUND = preload("res://assets/backgrounds/parallax_background.tscn")

const EFFECTS_BUS = &"Effects"

var background_sprite: Sprite2D



var canvas: CanvasLayer
var crossfade: Crossfade
var compass: TextureRect

func _add_core() -> void:
	core = CORE.instantiate()
	core.stats = boss
	core.global_position = $Planet/BossPositions.get_child(0).global_position
	core.positions = $Planet/BossPositions
	add_child(core)

func _ready() -> void:
	
	_add_core()
	
	spaceship.allow_inputs.append("start")
	spaceship.took_damage.connect(_player_took_damage)
	spaceship.dead.connect(_on_player_dead)
	
	canvas = GAME_CANVAS.instantiate()
	add_child(canvas)
	
	compass = canvas.get_node("Container/Compass/Arrow")
	
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
	
	
	$Door.door_closing.connect(_on_door_closing)
	
	
	canvas.get_node("Container/PlayerHealth").visible = false
	canvas.get_node("Container/BossHealth").visible = false
	
	canvas.get_node("Container/BossHealth/ProgressBar").max_value = core.max_health
	
	_on_core_health_changed()
	
	var pause := PAUSE.instantiate()
	pause.crossfade = crossfade
	pause.visible = false
	canvas.get_node("Container").add_child(pause)

func _on_door_closing() -> void:
	canvas.get_node("Container/PlayerHealth").visible = true
	canvas.get_node("Container/BossHealth").visible = true
	UiUtils.apply_transition(canvas.get_node("Container/PlayerHealth"))
	UiUtils.apply_transition(canvas.get_node("Container/BossHealth"))

func _process(delta: float) -> void:
	
	if is_instance_valid(core) && is_instance_valid(spaceship):
		var pos := core.global_position - spaceship.global_position
		
		compass.rotation = lerp_angle(compass.rotation, atan2(pos.y, pos.x), delta * 4.0)
	background_sprite.position += Vector2.ONE * delta * 4.0
	if background_sprite.position.x > 512:
		background_sprite.position -= Vector2.ONE * 512
	queue_redraw()

func _on_core_new_phase(_index: int) -> void:
	pass

func _on_core_health_changed() -> void:
	canvas.get_node("Container/BossHealth/ProgressBar").value = core.health
	canvas.get_node("Container/BossHealth/Text/Value").text = str(floor(core.health * 100.0 / core.max_health), "%")

func _on_core_dead() -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://ui/computer/computer.tscn")
func transition_ended() -> void:
	crossfade.start_a()
	spaceship.allow_inputs.erase("start")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _player_took_damage() -> void:
	$Camera.add_trauma(5.0)
	canvas.get_node("Container/PlayerHealth/ProgressBar").value = max(spaceship.health, 0)
	canvas.get_node("Container/PlayerHealth/Text/Value").text = str(spaceship.health, "/", spaceship.max_health)

var dp := []
func _draw() -> void:

	for p in dp:
		draw_circle(p, 10, Color.RED)


func is_point_colliding(point: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var query_point := PhysicsPointQueryParameters2D.new()
	query_point.position = point
	
	var result := space_state.intersect_point(query_point)
	
	if not result.is_empty():
		return true
	var query := PhysicsShapeQueryParameters2D.new()
	var circle_shape := CircleShape2D.new()
	circle_shape.radius = 32
	query.shape = circle_shape
	query.transform = Transform2D(0, point)
	var result2 = space_state.intersect_shape(query)
	return result2.size() > 0



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

func _get_random_valid_positions(count := 1) -> Array[Vector2]:
	var points: Array[Vector2] = []
	for i in range(count):
		var valid_position := false
		var max_attempts := 50
		var attempt := 0
		var pos := Vector2.ZERO
	
		while not valid_position and attempt < max_attempts:
			attempt += 1
			pos = (Vector2.RIGHT * randf_range(0, planet_radius)).rotated(randf_range(0, PI*2))
			# checks if the position is clear
			if not is_point_colliding(pos):
				valid_position = true
		if valid_position:
			points.append(pos)
	return points

func _create_enemy(enemy_id := "", pos := Vector2.ZERO) -> void:
	var enemy: Node2D
	if enemy_id == "":
		enemy_id = ENEMIES_TYPE.pick_random()
	
	match enemy_id:
		"default_eye":
			enemy = DEFAULT_EYE.instantiate()
		"spike_ball":
			enemy = SPIKE_BALL.instantiate()
		"bomber":
			enemy = BOMBER.instantiate()
		"laser_eye":
			enemy = LASER_EYE.instantiate()
	enemy.global_position = pos
	planet.add_child(enemy)

func _spawn_enemy(type := "", pos := Vector2.ZERO) -> void:
	var animation := ENEMY_SPAWN_ANIMATION.instantiate()
	animation.position = pos
	animation.done.connect(_create_enemy.bind(type, pos))
	planet.add_child(animation)
