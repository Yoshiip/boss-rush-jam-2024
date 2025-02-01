class_name LaserEye
extends AreaEnemy

func _process(delta: float) -> void:
	if $Laser.laser_time < 0.0:
		var diff := player.global_position - global_position
		global_rotation = lerp_angle(global_rotation, atan2(diff.y, diff.x), 2.0 * delta)

func _dead() -> void:
	super()
	$Laser.queue_free()
