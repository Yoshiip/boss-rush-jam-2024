class_name FightRoot
extends Node2D

@onready var spaceship: Spaceship = $Spaceship

const PAUSE = preload("res://ui/pause/pause.tscn")

func _ready() -> void:
	spaceship.allow_inputs.append("start")
	spaceship.took_damage.connect(_player_took_damage)
	spaceship.dead.connect(_on_player_dead)
	$Canvas/Container/PlayerHealth/ProgressBar.max_value = spaceship.max_health
	$Canvas/Container/PlayerHealth/ProgressBar.value = spaceship.max_health
	$Canvas/Container/PlayerHealth/Value.text = str(spaceship.health, "/", spaceship.max_health)
	
	var pause := PAUSE.instantiate()
	pause.crossfade = $Crossfade
	pause.visible = false
	$Canvas/Container.add_child(pause)
	



func transition_ended() -> void:
	$Crossfade.start_a()
	spaceship.allow_inputs.erase("start")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN



func _player_took_damage() -> void:
	$Camera.add_trauma(5.0)
	$Canvas/Container/PlayerHealth/ProgressBar.value = max(spaceship.health, 0)
	$Canvas/Container/PlayerHealth/Value.text = str(spaceship.health, "/", spaceship.max_health)


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
	$Crossfade.stop_both()
	$Canvas/Container/GameOver.start()


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

const BULLET_PARTICLES = preload("res://assets/bullets/bullet_particles.tscn")

func spawn_bullet_destroy_particles(at: Vector2, from_enemy: bool) -> void:
	var particles := BULLET_PARTICLES.instantiate()
	particles.position = at
	particles.from_enemy = from_enemy
	add_child(particles)
