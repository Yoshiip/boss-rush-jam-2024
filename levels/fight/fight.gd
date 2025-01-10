extends Node2D

@export var spin_speed := 0.05
@export var planet_radius := 200.0

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
	
	spawn_wave()
	
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

func spawn_wave() -> void:
	$Camera.add_trauma(25.0)
	for i in 2 + randi() % 2:
		var eye := DEFAULT_EYE.instantiate()
		var random_angle := randf() * PI * 2
		eye.position = Vector2(cos(random_angle), sin(random_angle)) * planet_radius
		$Planet.add_child(eye)

func _on_player_dead() -> void:
	get_tree().paused = true
	$Canvas/Container/GameOver.visible = true
