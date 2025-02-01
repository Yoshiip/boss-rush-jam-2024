extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Body/Sprite.position.y = 256
	$Body.collision_layer = 0


func _on_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Spaceship"):
		$Body.collision_layer = 1
		var tween := get_tree().create_tween()
		tween.tween_property($Body/Sprite, "position:y", 0, 5.0)
