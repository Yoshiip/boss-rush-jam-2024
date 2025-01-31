class_name Bullet
extends Area2D

@onready var ray_cast: RayCast2D = $RayCast
@onready var ray_cast_homing: RayCast2D = $RayCastHoming

@onready var root: FightRoot = get_tree().current_scene

const BULLET = preload("res://assets/bullets/bullet/bullet.tscn")

var from_enemy := false
var special_enemy_projectile := false
var damage := 1

var velocity := Vector2.ZERO
var homing_direction := Vector2.ZERO
var speed := 1.5
var bounces_count_bullet := 0
var bounces_count := 0



var bounce_powerup := false

var max_bounces := 2
var max_splits := 0
var max_pierces := 0
var max_deflects :=0
var max_infections := 0

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

func _physics_process(_delta: float) -> void:
	position += velocity * speed
	
	if ray_cast_homing.is_colliding():
		var coll := ray_cast_homing.get_collider()
		if coll && coll.is_in_group("enemy"):
			homing_direction = (coll.global_position - global_position).normalized()
			velocity = homing_direction


func destroy_bullet():
	#add some sort of explosion effect

	root.spawn_bullet_destroy_particles(global_position, from_enemy)
	queue_free() 

func bounce_of_position(pos: Vector2) -> void:
	var collision_normal := (pos - global_position).normalized()
	velocity = velocity.bounce(collision_normal)
	ray_cast.set_target_position(velocity.normalized()*30)
	ray_cast_homing.set_target_position(velocity.normalized()*300)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Spaceship") && from_enemy:
		body.take_damage(damage)
		destroy_bullet()
		#bullets bounce off of obstacles a number of times. player bullets bounce fewer times
	elif body.is_in_group("Enemy") && !from_enemy:
		body.take_damage(damage)
		destroy_bullet()
	elif body.is_in_group("Obstacle"):
		if bounce_powerup:
			speed *= 1.1
			scale = Vector2(scale.x * 1.2, scale.y * 1.2)
			damage += 1
		if ray_cast.is_colliding():
			var collision_normal = ray_cast.get_collision_normal()
		#var collision_normal = (body.global_position - global_position).normalized()
			velocity = velocity.bounce(collision_normal)
			ray_cast.set_target_position(velocity.normalized() * 30)
			if not from_enemy:
				ray_cast_homing.set_target_position(velocity.normalized() * 300)
				if max_bounces > 0:
					_fire()
					max_bounces -= 1
			bounces_count += 1
			
			if bounces_count>= max_bounces:
				destroy_bullet()
		else:
			destroy_bullet()
	
#lets enemy and player bullets bounce off of eachother
func _on_area_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet") && !from_enemy && body.from_enemy && max_deflects>0:
		var other_bullet := body
		bounces_count+=1
		max_deflects-= 1
			
		var collision_normal := (body.global_position - global_position).normalized()
		if !max_pierces > bounces_count_bullet:
			bounce_of_position(body.global_position)
		if max_infections > 0:
			modulate = Color.DARK_CYAN
			other_bullet.from_enemy = false
			other_bullet.modulate = Color.DARK_CYAN
			max_infections -=1
		speed *= 0.8 
		other_bullet.speed*=2
		other_bullet.velocity = other_bullet.velocity.bounce(-collision_normal)
		other_bullet.bounces_count+=1
		if other_bullet.bounce_powerup:
			other_bullet.speed*=1.1
			other_bullet.scale = Vector2(scale.x*1.2,scale.y*1.2)
	if body.is_in_group("Spikeball"):
		bounce_of_position(body.global_position)

const MIN_ANGLE = deg_to_rad(-45)
const MAX_ANGLE = deg_to_rad(45)

func _fire() -> void:
	var bullet := BULLET.instantiate()
	bullet.position = position
	bullet.speed = speed
	bullet.from_enemy = false

	var random_rotation := randf_range(MIN_ANGLE + rotation, MAX_ANGLE + rotation)
	bullet.rotation = random_rotation

	bullet.velocity = Vector2.RIGHT.rotated(rotation)
	
	if GameManager.is_deflect():
		bullet.max_deflects = GameManager.get_deflection()
		bullet.max_infections = GameManager.get_infection_bullet()
		bullet.max_pierces = GameManager.get_pierces()

	bullet.max_bounces = GameManager.get_bounces()
	bullet.bounces_count = bounces_count
	bullet.max_splits = GameManager.get_splits()-1
	bullet.scale = Vector2.ONE * GameManager.get_bullet_size()
	
	call_deferred("add_sibling", bullet)
