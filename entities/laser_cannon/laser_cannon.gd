extends AreaEnemy

func take_damage(amount: int) -> void:
	super(amount)
	$Laser.laser_time = 0.0
	$Laser.shoot_time = $Laser.max_shoot_timer
