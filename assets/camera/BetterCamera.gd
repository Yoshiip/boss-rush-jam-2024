class_name BetterCamera
extends Camera2D
@onready var target = $"../Spaceship"

var trauma := 0.0

func _process(delta: float) -> void:
	offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * trauma
	trauma *= 0.92 
	if target:
		global_position = lerp(global_position, target.global_position, 0.05)
		
func add_trauma(amount: float) -> void:
	trauma += amount
	
