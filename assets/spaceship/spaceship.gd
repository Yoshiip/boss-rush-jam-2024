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
var target_direction
#@export var stats : player_stats


@export var max_health := 10
@onready var health := max_health


const FIRE_SPEED = 0.25
@onready var fire_timer := FIRE_SPEED
var weapon_toggle =false
var switch_movemode = true

func _ready() -> void:
	$Sprite.material = $Sprite.material.duplicate()

func _handle_input(delta: float) -> void:
	var axis = Vector2(
	Input.get_axis("move_left", "move_right"),
	Input.get_axis("move_up", "move_down")
)
	#handle movement
	if axis.length() > 0:
		#smoothly change direction, instead of immediatly snapping to new direction
		if switch_movemode:
			var target_velocity = axis.normalized() * ACCELERATION_SPEED
			
			velocity = lerp(velocity, target_velocity, 25.0 * delta)
			
			var target_direction = position + velocity
			rotation =  lerp_angle(rotation, (target_direction - position).angle(), 5.0 * delta)
		else: 
			var goal_direction = axis.angle()
			rotation =  lerp_angle(rotation, goal_direction, 5.0 * delta)
			velocity = lerp(velocity, Vector2(cos(rotation), sin(rotation)) * ACCELERATION_SPEED, 10.0 * delta)

	else:
		velocity = velocity.lerp(Vector2.ZERO, 2.0 * delta)
		

	if Input.is_action_just_pressed("Weapon Toggle"):
		weapon_toggle= !weapon_toggle
	if Input.is_action_just_pressed("Switch_Movement"):
		switch_movemode= !switch_movemode
		
func _handle_weapon(delta: float) -> void:
	fire_timer -= delta
	if (weapon_toggle ||Input.is_action_pressed("fire")) && fire_timer <= 0.0:
		var bullet = BULLET.instantiate()
		bullet.position = position
		bullet.speed = 7
		bullet.from_enemy= false
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - global_position).normalized()
		bullet.rotation = direction.angle()
		bullet.velocity = Vector2.RIGHT.rotated(rotation)
		
		add_sibling(bullet)
		fire_timer = FIRE_SPEED
		bullet.infection_bullet=false
		#faster bullet is launched if you haven't been holding down fire,to encourage tactical play
		if Input.is_action_just_pressed("fire")&&1==0:
			bullet.speed =15
			bullet.scale = Vector2(1.4,1.4)
			bullet.bounce_number=-4
	elif  fire_timer <= 0.0:
		var axis_shoot = Vector2(
		Input.get_axis("attack_left", "attack_right"),
		Input.get_axis("attack_up", "attack_down")
	)
		if axis_shoot.length()>0:
			var bullet = BULLET.instantiate()
			bullet.position = position
			bullet.speed = 7
			bullet.from_enemy= false
			
			
			
			bullet.rotation = axis_shoot.angle()
			bullet.velocity = axis_shoot
			
			add_sibling(bullet)
			fire_timer = FIRE_SPEED
			bullet.infection_bullet=false
			bullet.bounce_powerup=true
				
		
		
		


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
