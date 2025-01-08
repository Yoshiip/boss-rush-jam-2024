extends Area2D


@export var max_health := 30
@onready var health := max_health

@onready var camera: BetterCamera = get_tree().current_scene.get_node("Camera")

var i := 0.0


		
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet") && !area.from_enemy:
		health -= area.damage
		if health == 0:
			
			$Sprite.texture = load("res://entities/core/place holder vulnerable part dead.png")
			
		camera.add_trauma(1)
		area.destroy_bullet()



func _process(delta: float) -> void:
	$Sprite.scale = Vector2.ONE * (0.9 + cos(i) * 0.1)
	i += delta
	
