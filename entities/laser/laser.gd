extends Node2D

@onready var ray_cast: RayCast2D = $RayCast
@export var on := false
@export var thickness := 0.0
@export var max_thickness := 64.0
var i := 0.0

func _process(delta: float) -> void:
	if on:
		thickness = lerp(thickness, max_thickness, 8.0 * delta)
	else:
		thickness = lerp(thickness, 0.0, 8.0 * delta)
	if thickness <= 0.1:
		return
	if ray_cast.is_colliding():
		var coll := ray_cast.get_collider()
		$Sprite.position = -ray_cast.get_collision_point() / 2
		$Sprite.scale.y = ray_cast.get_collision_point().length()
	$Sprite.scale.x = thickness / max_thickness + cos(i * 20.0) * 0.08
	i += delta
