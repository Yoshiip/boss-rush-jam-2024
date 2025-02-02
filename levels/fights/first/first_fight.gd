class_name FightBossRoot
extends FightRoot


func _ready() -> void:
	super()
	
	for pos in _get_random_valid_positions(3):
		_spawn_enemy("spike_ball", pos)
	for pos in _get_random_valid_positions(2):
		_spawn_enemy( "default_eye", pos)
	
	

func _on_core_new_phase(index: int) -> void:
	super(index)
	match index:
		1:
			for pos in _get_random_valid_positions(1):
				_spawn_enemy("spike_ball", pos)
			for pos in _get_random_valid_positions(2):
				_spawn_enemy( "default_eye", pos)
		2:
			for pos in _get_random_valid_positions(1):
				_spawn_enemy("spike_ball", pos)
			for pos in _get_random_valid_positions(3):
				_spawn_enemy( "default_eye", pos)
		3:
			for pos in _get_random_valid_positions(2):
				_spawn_enemy("spike_ball", pos)
			for pos in _get_random_valid_positions(0):
				_spawn_enemy( "default_eye", pos)
		4:
			for pos in _get_random_valid_positions(1):
				_spawn_enemy("spike_ball", pos)
			for pos in _get_random_valid_positions(5):
				_spawn_enemy( "default_eye", pos)
		5:
			for pos in _get_random_valid_positions(0):
				_spawn_enemy("spike_ball", pos)
			for pos in _get_random_valid_positions(2):
				_spawn_enemy( "default_eye", pos)
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
