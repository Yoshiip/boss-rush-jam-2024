class_name Bullet
extends Area2D

@onready var ray_cast: RayCast2D = $RayCast

@onready var root: FightRoot = get_tree().current_scene

var from_enemy := false
var special_enemy_projectile := false
var damage := 1

var velocity := Vector2.ZERO
var homing_direction := Vector2.ZERO
var speed := 1.5
var bounce_number := 0
@onready var ray_cast_homing: RayCast2D = $RayCastHoming
var collider : Object

var infection_bullet := false
var intangible_bullet := false
var bounce_powerup := false

func _ready() -> void:
	velocity = Vector2.RIGHT.rotated(rotation)
	set_rotation_degrees(360) 
	ray_cast.set_target_position(velocity.normalized() * 26)
	if !from_enemy:
		ray_cast_homing.set_target_position(velocity.normalized() * 400)
	
	if special_enemy_projectile:
		modulate = Color.WEB_PURPLE
	elif from_enemy:
		# we'il probably make a special bullet for enemy later
		bounce_number+=2
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
			bounce_number+=1
			
			if bounce_number>4:
				destroy_bullet()
		else:
			destroy_bullet()
	
		#lets enemy and player bullets bounce off of eachother
func _on_area_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet") && !from_enemy && body.from_enemy && !intangible_bullet:
		var other_bullet = body
		bounce_number+=1
			
		var collision_normal = (body.global_position - global_position).normalized()
		velocity = velocity.bounce(collision_normal)
		ray_cast.set_target_position(velocity.normalized()*30)
		if!from_enemy:
				ray_cast_homing.set_target_position(velocity.normalized()*300)
		speed *= 0.8 
		other_bullet.speed*=2
		other_bullet.velocity = other_bullet.velocity.bounce(-collision_normal)
		other_bullet.bounce_number+=1
		if other_bullet.bounce_powerup:
			other_bullet.speed*=1.1
			other_bullet.scale = Vector2(scale.x*1.2,scale.y*1.2)
			
		if infection_bullet && bounce_number<2:
			modulate =Color.DARK_CYAN
			other_bullet.from_enemy= false
			other_bullet.modulate = Color.DARK_CYAN
	
