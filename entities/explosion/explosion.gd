extends Area2D


const MAX_TIME := 1.0
@onready var time_left := MAX_TIME

func _ready() -> void:
	$Particles.emitting = true

func _process(delta: float) -> void:
	$Circle.scale = lerp(Vector2.ONE, Vector2.ZERO, time_left / MAX_TIME)
	time_left -= delta
	if time_left <= 0.0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Spaceship"):
		body.take_damage(3)
