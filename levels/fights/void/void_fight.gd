class_name LaserBomberIntroFightRoot
extends FightRoot


func _ready() -> void:
	super()
	
	
	
	
	

func _on_core_new_phase(index: int) -> void:
	super(index)
	match index:
		1:
			for pos in _get_random_valid_positions(1):
				_spawn_enemy("laser_eye", pos)
			for pos in _get_random_valid_positions(2):
				_spawn_enemy( "bomber", pos)
		2:
			for pos in _get_random_valid_positions(1):
				_spawn_enemy("laser_eye", pos)
			for pos in _get_random_valid_positions(2):
				_spawn_enemy( "bomber", pos)
		3:
			for pos in _get_random_valid_positions(2):
				_spawn_enemy("laser_eye", pos)
			for pos in _get_random_valid_positions(2):
				_spawn_enemy( "bomber", pos)
		4:
			for pos in _get_random_valid_positions(2):
				_spawn_enemy("laser_eye", pos)
			for pos in _get_random_valid_positions(2):
				_spawn_enemy( "bomber", pos)
		5:
			for pos in _get_random_valid_positions(2):
				_spawn_enemy("laser_eye", pos)
			for pos in _get_random_valid_positions(2):
				_spawn_enemy( "bomber", pos)
			pass

func _process(delta: float) -> void:
	super(delta)

func spawn_wave(count: int) -> void:
	for pos in _get_random_valid_positions(count):
		_spawn_enemy("default_eye", pos)


func spawn_spikes(num : float) -> void:
	for pos in _get_random_valid_positions(num):
		var spike = SPIKE_BALL.instantiate()
		spike.position = pos
		planet.add_child(spike)
