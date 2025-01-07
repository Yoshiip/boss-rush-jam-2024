extends Area2D

const SPEED = 10.0

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * SPEED




func destroy_bullet():
	#add some sort of explosion effect
	queue_free() 
