extends Area2D



@export var max_health := 30
@onready var health := max_health

@onready var camera: BetterCamera = get_tree().current_scene.get_node("Camera")

func _process(delta):
	if health<=0:
		#add a special effects for destruction
		queue_free() 

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		area.destroy_bullet()
		health -= 1
		camera.add_trauma(1)

	
