extends Area2D



var i := 0.0

func _process(delta: float) -> void:
	$Sprite.scale = Vector2.ONE * (0.9 + cos(i) * 0.1)
	i += delta
