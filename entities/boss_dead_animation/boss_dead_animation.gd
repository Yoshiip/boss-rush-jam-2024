extends Node2D

func _ready() -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	$Particles.emitting = true
	tween.tween_interval(1.0)
	tween.tween_property($Sprite, "scale", Vector2.ONE * 30, 5.0)
