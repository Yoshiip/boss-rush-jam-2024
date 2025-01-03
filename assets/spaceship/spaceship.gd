extends CharacterBody2D


const BULLET = preload("res://assets/bullets/bullet/bullet.tscn")
const ROTATE_SPEED = 180.0
const ACCELERATION_SPEED = 10.0
const FIRE_SPEED = 0.15

@onready var fire_timer := FIRE_SPEED
func _physics_process(delta: float) -> void:
	
	var planets = get_tree().get_nodes_in_group("Planet")
	
	if Input.is_action_pressed("steer_left"):
		rotation_degrees -= ROTATE_SPEED * delta
	if Input.is_action_pressed("steer_right"):
		rotation_degrees += ROTATE_SPEED * delta
	if Input.is_action_pressed("accelerate"):
		velocity += Vector2.RIGHT.rotated(rotation) * ACCELERATION_SPEED
	fire_timer -= delta
	if Input.is_action_pressed("fire") && fire_timer <= 0.0:
		var bullet = BULLET.instantiate()
		bullet.position = position
		bullet.rotation = rotation
		add_sibling(bullet)
		fire_timer = FIRE_SPEED
	velocity *= 0.92
	move_and_slide()
