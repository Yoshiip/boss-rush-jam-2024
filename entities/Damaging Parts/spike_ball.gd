extends Area2D

var damage = 2
# Called when the node enters the scene tree for the first time.
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Spaceship"):
		body.take_damage(damage)
