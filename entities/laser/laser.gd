extends Node2D

@onready var ray_cast: RayCast2D = $RayCast
@export var on := false
@export var thickness := 0.0
@export var max_thickness := 64.0
@export var length := 1000.0
var i := 0.0

@export var max_shoot_timer := 10.0
@export var max_laser_timer := 3.0

@onready var laser_time := max_laser_timer
@onready var shoot_time := max_shoot_timer


func _process(delta: float) -> void:
	shoot_time -= delta
	laser_time -= delta
	if shoot_time <= 0.0:
		laser_time = max_laser_timer
		shoot_time = max_shoot_timer
	on = laser_time > 0.0
	if on:
		if !$Active.playing:
			$Active.play()
			$Start.play()
		
		thickness = lerp(thickness, max_thickness, 8.0 * delta)
	else:
		if $Active.playing:
			$Active.stop()
			$Stop.play()
		thickness = lerp(thickness, 0.0, 8.0 * delta)
	$Particles.emitting = on
	
	i += delta
	var anim := cos(i * 20.0) * 0.08 if on else 0.0
	$Sprite.scale.x = thickness / max_thickness + anim
	
	if thickness <= 0.1:
		return
	$RayCast.target_position = Vector2.RIGHT * length
	
	if ray_cast.is_colliding():
		var coll := ray_cast.get_collider()
		if is_instance_valid(coll) && coll.is_in_group("Spaceship") && laser_time + 0.5 < max_laser_timer:
			coll.take_damage(2, global_position)
		$Sprite.scale.y = (ray_cast.get_collision_point() - global_position).length()
		$Particles.global_position = ray_cast.get_collision_point()
