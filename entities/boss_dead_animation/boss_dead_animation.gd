extends Node2D

func _ready() -> void:
	var tween := get_tree().create_tween()
	$Particles.emitting = true
	tween.tween_interval(1.0)
	tween.tween_property($Sprite, "scale", Vector2.ONE * 30, 10.0)
