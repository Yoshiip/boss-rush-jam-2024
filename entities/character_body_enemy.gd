class_name CharacterBodyEnemy
extends CharacterBody2D

@export var max_health := 10.0
@onready var health := max_health


@onready var camera: BetterCamera =get_viewport().get_camera_2d()
@onready var player: Spaceship = get_tree().get_first_node_in_group("Spaceship")

func _ready() -> void:
	$Sprite.material = $Sprite.material.duplicate()
	add_to_group(&"Enemy")


@export var dead_texture: CompressedTexture2D

func take_damage(amount: float) -> void:
	health -= amount
	camera.add_trauma(2)

	if health <= 0:
		$Sprite.texture = dead_texture
		$Death.play()
		camera.add_trauma(5)
		queue_free()
	else:
		$Sprite.material.set_shader_parameter("whitening", 1.0)
		var tween := get_tree().create_tween()
		tween.tween_property($Sprite.material, "shader_parameter/whitening", 0.0, 0.2)
		
