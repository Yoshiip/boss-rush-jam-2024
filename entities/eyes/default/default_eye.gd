class_name DefaultEye
extends AreaEnemy


@export var max_shoot_timer := 1.0
@onready var shoot_timer := max_shoot_timer

@export_range(0.0, 1.0) var special_chance = 0.2
@export_range(0.0, PI / 3) var accurracy = 0.2
@export var bullet_speed = 2


var BULLET = load("res://assets/bullets/bullet/bullet.tscn")

@onready var spaceship: Spaceship = get_tree().get_first_node_in_group(&"Spaceship")

func _process(delta: float) -> void:
	shoot_timer -= delta
	if is_instance_valid(player):
		var diff := player.global_position - global_position
		global_rotation = lerp_angle(global_rotation, atan2(diff.y, diff.x), 2.0 * delta)

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
	bullet.position = $ShootPoint.global_position
	bullet.look_at(spaceship.global_position)
	bullet.rotation += rotation_offset
	bullet.velocity = Vector2.RIGHT.rotated(rotation)
	bullet.speed = bullet_speed
	
	if bullet.speed > 3:
		bullet.modulate = Color.ORANGE_RED
	else:
		bullet.modulate = Color.RED
	get_tree().current_scene.add_child(bullet)
