class_name LaserEye
extends CharacterBodyEnemy


@export var max_shoot_timer := 1.0
@onready var shoot_timer := max_shoot_timer

@export var default_speed := 60.0
@export var speed := 0.0


@export_range(0.0, 1.0) var special_chance = 0.2
@export_range(0.0, PI / 3) var accurracy = 0.2
@export var bullet_speed = 2

@onready var spaceship: Spaceship = get_tree().get_first_node_in_group(&"Spaceship")


func _ready() -> void:
	super()
	if randf() > 0.6:
		speed = 0


func _process(delta: float) -> void:
	if is_instance_valid(spaceship):
		look_at(spaceship.global_position)
		velocity = velocity.lerp((spaceship.global_position - global_position).normalized() * speed, 0.5 * delta)
		move_and_slide()
	if $LaserRaycast.is_colliding():
		var coll = $LaserRaycast.get_collider()
		$Laser.scale.y = ($LaserRaycast.get_collision_point() - global_position).length()
		$Particles.position.x = ($LaserRaycast.get_collision_point() - global_position).length() - $LaserRaycast.position.length()
	shoot_timer -= delta
	if shoot_timer <= 0.0:
		shoot_timer = max_shoot_timer
