class_name DefaultEye
extends Area2D

@export var max_health := 10
@onready var health := max_health

@export var max_shoot_timer := 0.01
@onready var shoot_timer := max_shoot_timer

@export_range(0.0, 1.0) var special_chance = 0.2
@export_range(0.0, PI / 3) var accurracy = 0.2
@export var bullet_speed = 2

@onready var camera: BetterCamera = get_tree().current_scene.get_node("Camera")

var BULLET = load("res://assets/bullets/bullet/bullet.tscn")

const DEAD_TEXTURE = preload("res://entities/eyes/default/eye_dead.png")

var spaceship: Spaceship

func _ready() -> void:
	$Sprite.material = $Sprite.material.duplicate()
	spaceship = get_tree().get_first_node_in_group("Spaceship")

func _process(delta: float) -> void:
	look_at(spaceship.global_position)
	
	shoot_timer -= delta
	if shoot_timer <= 0.0:
		shoot_timer = max_shoot_timer
		if randf() < special_chance:
			_do_special()
		else:
			_shoot_bullet(randf_range(-accurracy, accurracy))

func _do_special() -> void:
	if randi() % 2 == 0:
		_shoot_bullet(-accurracy / 2)
		_shoot_bullet(0)
		_shoot_bullet(accurracy / 2)
	else:
		for i in range(randi_range(3, 5)):
			_shoot_bullet(randf_range(-accurracy, accurracy))
			await get_tree().create_timer(max_shoot_timer / 5.0).timeout
	


func _shoot_bullet(rotation_offset: float) -> void:
	if !is_instance_valid(spaceship):
		return
	var bullet: Bullet = BULLET.instantiate()
	bullet.from_enemy = true
	bullet.position = global_position
	bullet.look_at(spaceship.global_position)
	bullet.rotation += rotation_offset
	bullet.velocity = Vector2.RIGHT.rotated(rotation)
	bullet.speed = bullet_speed
	
	if bullet.speed > 3:
		bullet.modulate = Color.ORANGE_RED
	else:
		bullet.modulate = Color.RED
	get_tree().current_scene.add_child(bullet)
		

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet") and health > 0 and not area.from_enemy:
		health -= area.damage
		camera.add_trauma(2)
	
		if health <= 0:
			$Sprite.texture = DEAD_TEXTURE
			print("rip")
			var tween := get_tree().create_tween().bind_node(self)
			tween.tween_property($Sprite, "modulate", Color.DIM_GRAY, 0.5)
			camera.add_trauma(10)
			set_process(false)
			
		else:
			$Sprite.material.set_shader_parameter("whitening", 1.0)
			var tween := get_tree().create_tween()
			tween.tween_property($Sprite.material, "shader_parameter/whitening", 0.0, 0.2)
		area.destroy_bullet()
