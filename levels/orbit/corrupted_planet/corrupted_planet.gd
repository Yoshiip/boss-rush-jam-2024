class_name CorruptedPlanet
extends Planet

@export var max_health := 30
@onready var health := max_health

@onready var camera: BetterCamera = get_tree().current_scene.get_node("Camera")


func _ready() -> void:
	$Overlay/Label.text = str(health, "/", max_health)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		health -= 1
		camera.add_trauma(5)

		$Overlay/Label.text = str(health, "/", max_health)



func _on_body_entered(body: Node2D) -> void:
	if health <= 0 && body.is_in_group("Spaceship"):
		get_tree().change_scene_to_file("res://levels/fight/fight.tscn")
