extends Area2D

const SPEED = 10.0

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * SPEED
