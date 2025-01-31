extends Area2D

var damage := 2

func _ready() -> void:
	add_to_group(&"Enemy")


func _process(delta: float) -> void:
	$Sprite.rotation += delta * 0.2
	$Sprite.scale = $Sprite.scale.lerp(Vector2.ONE, delta * 2.0)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Spaceship"):
		$Sprite.scale = Vector2.ONE * 1.5
		body.take_damage(damage, global_position)
