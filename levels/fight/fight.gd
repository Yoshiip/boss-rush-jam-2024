extends Node2D

@export var spin_speed := 0.05
@onready var spaceship: Spaceship = $Spaceship

func _ready() -> void:
	spaceship.took_damage.connect(_player_took_damage)
	$Canvas/Container/PlayerHealth/ProgressBar.max_value = spaceship.max_health

func _process(delta: float) -> void:
	$Planet.rotation += delta * spin_speed


func _player_took_damage() -> void:
	$Camera.add_trauma(5.0)
	$Canvas/Container/PlayerHealth/ProgressBar.value = spaceship.health
	$Canvas/Container/PlayerHealth/Value.text = str(spaceship.health, "/", spaceship.max_health)
