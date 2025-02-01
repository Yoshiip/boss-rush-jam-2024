extends Node2D

signal door_closing

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Body/Sprite.position.y = 256
	$Body.collision_layer = 0



var playing := false
func _on_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Spaceship") && !playing:
		playing = true
		$Body.collision_layer = 1
		door_closing.emit()
		var tween := get_tree().create_tween()
		tween.tween_property($Body/Sprite, "position:y", 0, 2.0)
