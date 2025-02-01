class_name FightBossRoot
extends FightRoot


func _ready() -> void:
	super()
	
	for pos in _get_random_valid_positions(3):
		_spawn_enemy("spike_ball", pos)
	for pos in _get_random_valid_positions(2):
		_spawn_enemy( "default_eye", pos)
	spawn_wave(5)
	

func _on_core_new_phase(index: int) -> void:
	super(index)
	match index:
		1:
			_spawn_enemy("spike_ball", _get_random_valid_positions()[0])
		2:
			for pos in _get_random_valid_positions(2):
				_spawn_enemy("laser_eye", pos)
				_spawn_enemy("bomber", pos)
		3:
			var pos := _get_random_valid_positions(3)
			_spawn_enemy("laser_eye", pos[0])
			_spawn_enemy("bomber", pos[1])
			_spawn_enemy("laser_eye", pos[0])
			spawn_wave(2)
		4:
			spawn_wave(4)
			_spawn_enemy("spike_ball", _get_random_valid_positions()[0])
		5:
			spawn_wave(5)
			pass

func _process(delta: float) -> void:
	super(delta)

func spawn_wave(count: int) -> void:
	for pos in _get_random_valid_positions(count):
		_spawn_enemy("", pos)
