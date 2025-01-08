extends Area2D

var from_enemy := false
var damage := 1

var velocity
var speed = 10.0
var bounce_number=0

func _ready() -> void:
	velocity = Vector2.RIGHT.rotated(rotation)
	rotation = 0
	if from_enemy:
		# we'il probably make a special bullet for enemy later
		modulate = Color.RED
		
		speed *= 0.6

func _physics_process(delta: float) -> void:
	position += velocity * speed


func destroy_bullet():
	#add some sort of explosion effect
	queue_free() 


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Spaceship") && from_enemy:
		body.take_damage(damage)
		queue_free()
		#bullets bounce off of obstacles a number of times. player bullets bounce fewer times
	elif body.is_in_group("Obstacle"):
		var collision_normal = (body.global_position - global_position).normalized()
		velocity = velocity.bounce(collision_normal)
		bounce_number+=1
		if !from_enemy:
			bounce_number+=2
	if bounce_number>7:
		queue_free()
	
		#lets enemy and player bullets bounce off of eachother
func _on_area_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet") && !from_enemy:
		var other_bullet = body
		bounce_number+=1
			
		var collision_normal = (body.global_position - global_position).normalized()
		velocity = velocity.bounce(collision_normal)
		speed = 9
		other_bullet.speed=9
		other_bullet.velocity = other_bullet.velocity.bounce(-collision_normal)
		other_bullet.bounce_number+=1
	
