class_name Spaceship
extends CharacterBody2D

signal took_damage
signal dead


const BULLET = preload("res://assets/bullets/bullet/bullet.tscn")

const ACCELERATION_SPEED = 400.0
const FRICTION_COEFF = 1.5

var acceleration_force := Vector2.ZERO
var friction_force := Vector2.ZERO
var net_force := Vector2.ZERO
var axis_shoot
var target_direction
#@export var stats : player_stats
@onready var root: FightRoot = get_tree().current_scene

@export var max_health := 10
@onready var health := max_health

# Only allow inputs if is empty
var allow_inputs: Array[String] = []


const FIRE_SPEED = 0.25
@onready var fire_timer := FIRE_SPEED
var weapon_toggle := false
var switch_movemode := true
var infection_bullet := false
var intangible_bullet := false
var bounce_powerup := true

func _is_allowed_inputs() -> bool:
	return allow_inputs.is_empty()

func _ready() -> void:
	$Sprite.material = $Sprite.material.duplicate()

func _handle_input(delta: float) -> void:
	var axis := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	) if _is_allowed_inputs() else Vector2.ZERO
	#handle movement
	if axis.length() > 0:
		#smoothly change direction, instead of immediatly snapping to new direction
		if switch_movemode:
			var target_velocity := axis.normalized() * ACCELERATION_SPEED
			
			velocity = lerp(velocity, target_velocity, 25.0 * delta)
			
			var target_direction := position + velocity
			rotation =  lerp_angle(rotation, (target_direction - position).angle(), 5.0 * delta)
		else: 
			var goal_direction := axis.angle()
			rotation =  lerp_angle(rotation, goal_direction, 5.0 * delta)
			velocity = lerp(velocity, Vector2(cos(rotation), sin(rotation)) * ACCELERATION_SPEED, 10.0 * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, 2.0 * delta)

	$EngineParticles.emitting = velocity.length() > 1.0

	if _is_allowed_inputs():
		if Input.is_action_just_pressed("weapon_toggle"):
			weapon_toggle= !weapon_toggle
		if Input.is_action_just_pressed("switch_movement"):
			switch_movemode= !switch_movemode


func _fire() -> Bullet:
	$Shoot.play()
	var bullet = BULLET.instantiate()
	bullet.position = position
	bullet.speed = 7
	bullet.from_enemy = false
	
	if axis_shoot && axis_shoot.length() > 0:
		bullet.rotation = axis_shoot.angle()
		bullet.velocity = axis_shoot.angle()
	else:
		var mouse_position := get_global_mouse_position()
		var direction := (mouse_position - global_position).normalized()
		bullet.rotation = direction.angle()
		bullet.velocity = Vector2.RIGHT.rotated(rotation)
	bullet.infection_bullet = infection_bullet 
	bullet.intangible_bullet = intangible_bullet 
	bullet.bounce_powerup = bounce_powerup 
	add_sibling(bullet)
	fire_timer = FIRE_SPEED
	bullet.infection_bullet = false
	return bullet


func _handle_weapon(delta: float) -> void:
	fire_timer -= delta
	if !_is_allowed_inputs():
		return
	if (weapon_toggle || Input.is_action_pressed("fire")) && fire_timer <= 0.0:
		var bullet := _fire()

		if 0==1 && Input.is_action_just_pressed("fire"):
			bullet.speed = 15
			bullet.scale = Vector2(1.4, 1.4)
			bullet.bounce_number = -4
	elif fire_timer <= 0.0:
		axis_shoot = Vector2(
		Input.get_axis("attack_left", "attack_right"),
		Input.get_axis("attack_up", "attack_down")
	)
	
		if axis_shoot.length() > 0:
			var bullet := _fire()


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
		$Hit.play()
	else:
		$GameOver.play()
		dead.emit()
		queue_free()
