extends Area2D


const MAX_TIME := 1.0
@onready var time_left := MAX_TIME

func _ready() -> void:
	$Particles.emitting = true

var inside := []

func _process(delta: float) -> void:
	time_left -= delta
	if time_left <= 0.0:
		get_viewport().get_camera_2d().add_trauma(15.0)
		queue_free()



var hitted := false
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Spaceship") and not hitted:
		hitted = true
		body.take_damage(3, global_position)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Spaceship"):
		inside.erase(body)
