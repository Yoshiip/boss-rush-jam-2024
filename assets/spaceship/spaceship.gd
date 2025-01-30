class_name Spaceship
extends CharacterBody2D

signal took_damage
signal dead

const BULLET = preload("res://assets/bullets/bullet/bullet.tscn")

const FRICTION_COEFF = 1.5

const BULLETS_SPEED := [7, 10, 13, 16]


var acceleration_force := Vector2.ZERO
var friction_force := Vector2.ZERO
var net_force := Vector2.ZERO
var axis_shoot := Vector2.ZERO

@onready var root: FightRoot = get_tree().current_scene

@export var max_health := GameManager.get_health()
@onready var health := max_health

@onready var shoot_point: Marker2D = $ShootPoint


# Only allow inputs if is empty
var allow_inputs: Array[String] = []

const FIRE_RATES := [0.25, 0.22, 0.19, 0.16]
@onready var fire_rate: float = FIRE_RATES[GameManager.save_data.fire_rate]


const SPEEDS := [400, 500, 600, 700, 800]
@onready var acceleration_speed: float = SPEEDS[GameManager.save_data.thrusters]

var fire_timer := fire_rate
var weapon_toggle := false
var switch_movemode := false
var deflection_bullet := false


func _is_allowed_inputs() -> bool:
	return allow_inputs.is_empty()

func _ready() -> void:
	$Sprite.material = $Sprite.material.duplicate()

func _handle_input(delta: float) -> void:
	var axis := Input.get_vector(
		"move_left", "move_right", "move_up", "move_down") if _is_allowed_inputs() else Vector2.ZERO
	
	
	$EngineParticles.emitting = axis.length() > 0.25
	#handle movement
	if axis.length() > 0:
		#smoothly change direction, instead of immediatly snapping to new direction
		if switch_movemode:
			var target_velocity := axis.normalized() * acceleration_speed
			
			velocity = lerp(velocity, target_velocity, 25.0 * delta)
			
			var target_direction := position + velocity
			rotation =  lerp_angle(rotation, (target_direction - position).angle(), 5.0 * delta)
		else: 
			var goal_direction := axis.angle()
			var dot_product = Vector2(cos(rotation), sin(rotation)).dot(axis)
			rotation =  lerp_angle(rotation, goal_direction, 7.0 * delta)
			if dot_product >=0.7:
				velocity = lerp(velocity, Vector2(cos(rotation), sin(rotation)) * acceleration_speed, 10.0 * delta)
			else:
				velocity = lerp(velocity, Vector2(cos(rotation), sin(rotation)) * acceleration_speed * dot_product, 10.0 * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, 2.0 * delta)
		
	if _is_allowed_inputs():
		if Input.is_action_just_pressed("weapon_toggle"):
			weapon_toggle= !weapon_toggle
		if Input.is_action_just_pressed("switch_movement"):
			switch_movemode= !switch_movemode


func _fire() -> Bullet:
	$Shoot.play()
	var bullet = BULLET.instantiate()
	bullet.position = $ShootPoint.global_position
	bullet.speed = 7
	#bullet.speed = BULLETS_SPEED[GameManager.save_data.bullet_speed]
	bullet.from_enemy = false
	
	if axis_shoot && axis_shoot.length() > 0:
		bullet.rotation = axis_shoot.angle()
		bullet.velocity = Vector2.RIGHT.rotated(rotation)
	else:
		var mouse_position := get_global_mouse_position()
		var direction := (mouse_position - global_position).normalized()
		bullet.rotation = direction.angle()
		bullet.velocity = Vector2.RIGHT.rotated(rotation)
	if GameManager.save_data.deflection_bullet:
		bullet.deflection_bullet = true
		bullet.infection_bullet_lvl =  GameManager.save_data.infection_level
		bullet.pierce_lvl = GameManager.save_data.pierce_level
	bullet.max_bounces = GameManager.get_bounces()
	bullet.max_splits = GameManager.get_splits()
	bullet.scale = Vector2.ONE * GameManager.get_bullet_size()

	add_sibling(bullet)
	fire_timer = fire_rate
	
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
		axis_shoot = Input.get_vector(
			"attack_left", "attack_right", "attack_up", "attack_down"
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
	check_if_crushed()
	#var coll := move_and_collide(velocity * delta)
	#if coll:
		#for object in coll.get_collider()


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
		
func check_if_crushed() -> void:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = position
	var result = space_state.intersect_point(query)

	if result.size() > 1:
		take_damage(10)
		


func _on_crush_detection_body_entered(body: Node2D) -> void:
	take_damage(100)
