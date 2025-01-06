extends CharacterBody2D


const BULLET = preload("res://assets/bullets/bullet/bullet.tscn")

const ROTATE_SPEED = 310.0
const ACCELERATION_SPEED = 300.0
const FRICTION_COEFF = 0.75

var acceleration_force := Vector2.ZERO
var friction_force := Vector2.ZERO
var net_force := Vector2.ZERO


const FIRE_SPEED = 0.15
@onready var fire_timer := FIRE_SPEED

func _handle_input(delta: float) -> void:
	if Input.is_action_pressed("steer_left"):
		rotation_degrees -= ROTATE_SPEED * delta
	if Input.is_action_pressed("steer_right"):
		rotation_degrees += ROTATE_SPEED * delta
	if Input.is_action_pressed("accelerate"):
		acceleration_force = Vector2.RIGHT.rotated(rotation) * ACCELERATION_SPEED # forward

func _handle_weapon(delta: float) -> void:
	fire_timer -= delta
	if Input.is_action_pressed("fire") && fire_timer <= 0.0:
		var bullet = BULLET.instantiate()
		bullet.position = position
		bullet.rotation = rotation
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - global_position).normalized()
		bullet.rotation = direction.angle()
		
		add_sibling(bullet)
		fire_timer = FIRE_SPEED


func _apply_force(delta: float) -> void:
	friction_force = -velocity.normalized() * velocity.length() * FRICTION_COEFF
	net_force = acceleration_force + friction_force
	velocity += net_force * delta

func _physics_process(delta: float) -> void:
	acceleration_force = Vector2.ZERO
	
	_handle_input(delta)
	_handle_weapon(delta)
	_apply_force(delta)
	
	move_and_slide()
