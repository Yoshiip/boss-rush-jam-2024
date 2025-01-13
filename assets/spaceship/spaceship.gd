class_name Spaceship
extends CharacterBody2D

signal took_damage
signal dead

const BULLET = preload("res://assets/bullets/bullet/bullet.tscn")

const ACCELERATION_SPEED = 350.0
const FRICTION_COEFF = 1.5

var acceleration_force := Vector2.ZERO
var friction_force := Vector2.ZERO
var net_force := Vector2.ZERO


@export var max_health := 10
@onready var health := max_health


const FIRE_SPEED = 0.2
@onready var fire_timer := FIRE_SPEED
var weapon_toggle =false

func _ready() -> void:
	$Sprite.material = $Sprite.material.duplicate()

func _handle_input(delta: float) -> void:
	var axis = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	if axis.length() > 0:
		velocity = velocity.lerp(axis.normalized() * ACCELERATION_SPEED, 20.0 * delta)
		look_at(position+velocity)
	else:
		velocity = velocity.lerp(Vector2.ZERO, 2.0 * delta)
	if Input.is_action_just_pressed("Weapon Toggle"):
		weapon_toggle= !weapon_toggle
		
func _handle_weapon(delta: float) -> void:
	fire_timer -= delta
	if (weapon_toggle ||Input.is_action_pressed("fire")) && fire_timer <= 0.0:
		var bullet = BULLET.instantiate()
		bullet.position = position
		bullet.speed = 9
		bullet.from_enemy= false
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - global_position).normalized()
		bullet.rotation = direction.angle()
		bullet.velocity = Vector2.RIGHT.rotated(rotation)
		
		add_sibling(bullet)
		fire_timer = FIRE_SPEED
		if Input.is_action_just_pressed("fire"):
			bullet.speed =15
			bullet.scale = Vector2(1.4,1.4)
			bullet.bounce_number=-4
		
		
		


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
	if health > 0:
		$Sprite.material.set_shader_parameter("whitening", 1.0)
		var tween := get_tree().create_tween()
		tween.tween_property($Sprite.material, "shader_parameter/whitening", 0.0, 0.2)
	else:
		dead.emit()
		queue_free()
