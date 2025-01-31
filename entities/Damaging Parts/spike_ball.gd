extends Area2D

var damage := 2

func _ready() -> void:
	add_to_group(&"Enemy")


func _process(delta: float) -> void:
	$Sprite.rotation += delta * 0.2


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Spaceship"):
		body.take_damage(damage, global_position)
