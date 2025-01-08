class_name Spaceship
extends CharacterBody2D

signal took_damage

const BULLET = preload("res://assets/bullets/bullet/bullet.tscn")

const ROTATE_SPEED = 400.0
const ACCELERATION_SPEED = 400.0
const FRICTION_COEFF = 1

var acceleration_force := Vector2.ZERO
var friction_force := Vector2.ZERO
var net_force := Vector2.ZERO

@export var max_health := 10
@onready var health := max_health


const FIRE_SPEED = 0.25
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
	if (1==1 || Input.is_action_pressed("fire") )&& fire_timer <= 0.0:
		var bullet = BULLET.instantiate()
		bullet.position = position
		bullet.speed = 6
		bullet.from_enemy= false
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - global_position).normalized()
		bullet.rotation = direction.angle()
		bullet.velocity = Vector2.RIGHT.rotated(rotation)
		
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

func take_damage(amount: int) -> void:
	health -= amount
	took_damage.emit()
