class_name BetterCamera
extends Camera2D


@onready var spaceship: Spaceship = $"../Spaceship"
@onready var core: Area2D = $"../Core"


var trauma := 0.0

func _process(delta: float) -> void:
	offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * trauma
	trauma *= 0.92
	if is_instance_valid(spaceship) && is_instance_valid(core):
		global_position = lerp(spaceship.global_position, core.global_position, 0.08)
		
func add_trauma(amount: float) -> void:
	trauma += amount
	
