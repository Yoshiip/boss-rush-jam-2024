class_name Bullet
extends Area2D

@onready var ray_cast: RayCast2D = $RayCast

@onready var root: FightRoot = get_tree().current_scene
const BULLET = preload("res://assets/bullets/bullet/bullet.tscn")

var from_enemy := false
var special_enemy_projectile := false
var damage := 1

var velocity := Vector2.ZERO
var homing_direction := Vector2.ZERO
var speed := 1.5
var bounce_number_bullet := 0
var bounce_number := 0
@onready var ray_cast_homing: RayCast2D = $RayCastHoming
var collider : Object

var deflection_bullet := false
var infection_bullet_lvl = 0
var bounce_powerup := false
var bounce_lvl =2
var pierce_lvl =0
var split_bounce_lvl =0 

func _ready() -> void:
	velocity = Vector2.RIGHT.rotated(rotation)
	set_rotation_degrees(360) 
	ray_cast.set_target_position(velocity.normalized() * 26)
	if !from_enemy:
		ray_cast_homing.set_target_position(velocity.normalized() * 400)
	
	if special_enemy_projectile:
		modulate = Color.WEB_PURPLE
		# we'il probably make a special bullet for enemy later
		
		#speed *= 0.2

func _physics_process(delta: float) -> void:
	position += velocity * speed
	
	if from_enemy:
		pass
	elif ray_cast_homing.is_colliding():
		collider = ray_cast_homing.get_collider()
		if collider && collider.is_in_group("enemy"):
			homing_direction = (collider.global_position - global_position).normalized()
			velocity = homing_direction


func destroy_bullet():
	#add some sort of explosion effect
	queue_free() 


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Spaceship") && from_enemy:
		body.take_damage(damage)
		destroy_bullet()
		#bullets bounce off of obstacles a number of times. player bullets bounce fewer times
	elif body.is_in_group("Obstacle"):
	
		if bounce_powerup:
			speed*=1.1
			scale = Vector2(scale.x*1.2,scale.y*1.2)
			damage += 1
		if ray_cast.is_colliding():
			var collision_normal = ray_cast.get_collision_normal()
		#var collision_normal = (body.global_position - global_position).normalized()
			velocity = velocity.bounce(collision_normal)
			ray_cast.set_target_position(velocity.normalized()*30)
			if!from_enemy:
				ray_cast_homing.set_target_position(velocity.normalized()*300)
				if split_bounce_lvl>0:
					var bullet := _fire()
					split_bounce_lvl-=1
			bounce_number+=1
			
			if bounce_number>= bounce_lvl:
				destroy_bullet()
		else:
			destroy_bullet()
	
		#lets enemy and player bullets bounce off of eachother
func _on_area_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet") && !from_enemy && body.from_enemy && deflection_bullet:
		var other_bullet = body
		bounce_number+=1
			
		var collision_normal = (body.global_position - global_position).normalized()
		if !pierce_lvl> bounce_number_bullet:
			velocity = velocity.bounce(collision_normal)
			ray_cast.set_target_position(velocity.normalized()*30)
			ray_cast_homing.set_target_position(velocity.normalized()*300)
		if infection_bullet_lvl> bounce_number_bullet:
			modulate =Color.DARK_CYAN
			other_bullet.from_enemy= false
			other_bullet.modulate = Color.DARK_CYAN
		bounce_number_bullet+=1
		speed *= 0.8 
		other_bullet.speed*=2
		other_bullet.velocity = other_bullet.velocity.bounce(-collision_normal)
		other_bullet.bounce_number+=1
		if other_bullet.bounce_powerup:
			other_bullet.speed*=1.1
			other_bullet.scale = Vector2(scale.x*1.2,scale.y*1.2)
			
	
	
func _fire() -> Bullet:
	
	var bullet = BULLET.instantiate()
	bullet.position = position
	bullet.speed = speed
	bullet.from_enemy = false
	var min_angle = deg_to_rad(-45)  # Convert -30 degrees to radians
	var max_angle = deg_to_rad(45)   # Convert 30 degrees to radians

	var random_rotation = randf_range(min_angle+ rotation, max_angle+rotation)
	
	bullet.rotation = random_rotation

	bullet.velocity = Vector2.RIGHT.rotated(rotation)
	if GameManager.save_data.deflection_bullet:
		bullet.deflection_bullet = true
		bullet.infection_bullet_lvl =  GameManager.save_data.infection_level
		bullet.pierce_lvl = GameManager.save_data.pierce_level
	bullet.bounce_lvl = GameManager.save_data.bounce_level
	bullet.bounce_number = bounce_number
	bullet.split_bounce_lvl = 0
	bullet.scale = Vector2(scale.x*GameManager.save_data.bullet_size,scale.y*GameManager.save_data.bullet_size)

	add_sibling(bullet)

	
	return bullet
