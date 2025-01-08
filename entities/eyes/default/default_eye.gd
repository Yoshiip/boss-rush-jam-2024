class_name DefaultEye
extends Area2D

@export var max_health := 3
@onready var health := max_health

@export var max_shoot_timer := 0.5
@onready var shoot_timer := max_shoot_timer

@export_range(0.0, 1.0) var special_chance = 0.2
@export_range(0.0, PI/3) var accurracy = 0.2

var spaceship: Spaceship

func _ready() -> void:
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
	

const BULLET = preload("res://assets/bullets/bullet/bullet.tscn")
func _shoot_bullet(rotation_offset: float) -> void:
	var bullet := BULLET.instantiate()
	bullet.from_enemy = true
	bullet.position = global_position
	bullet.speed = 3
	bullet.look_at(spaceship.global_position)
	bullet.rotation += rotation_offset
	bullet.velocity = Vector2.RIGHT.rotated(rotation)
	get_tree().current_scene.add_child(bullet)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet") and not area.from_enemy:
		health -= area.damage
		if health <= 0:
			queue_free()
		area.destroy_bullet()
