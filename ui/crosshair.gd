extends TextureRect


var i := 0.0

func _process(delta: float) -> void:
	visible = Input.mouse_mode == Input.MOUSE_MODE_HIDDEN
	position = position.lerp(get_global_mouse_position() - size*0.5, 35.0 * delta)
	rotation += delta * 0.5
	scale = Vector2.ONE * (0.6 + cos(i) * 0.1)
	i += delta * 2.0
