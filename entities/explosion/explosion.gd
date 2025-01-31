extends Area2D


const MAX_TIME := 1.0
@onready var time_left := MAX_TIME

func _ready() -> void:
	$Particles.emitting = true

var inside := []

func _process(delta: float) -> void:
	$Sprite.scale = lerp(Vector2.ONE, Vector2.ZERO, time_left / MAX_TIME)
	time_left -= delta
	if time_left <= 0.0:
		for body in inside:
			get_viewport().get_camera_2d().add_trauma(15.0)
			body.take_damage(3, global_position)
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Spaceship"):
		inside.append(body)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Spaceship"):
		inside.erase(body)
