class_name TerrainFightRoot
extends FightRoot


func _on_core_new_phase(index: int) -> void:
	match index:
		1:
			for pos in _get_random_valid_positions(1):
				_spawn_enemy("spike_ball", pos)
		2:
			var pos := _get_random_valid_positions(2)
			_spawn_enemy("spike_ball", pos[0])
			_spawn_enemy("default_eye", pos[1])
		3:
			var pos := _get_random_valid_positions(3)
			_spawn_enemy("spike_ball", pos[0])
			_spawn_enemy("default_eye", pos[1])
			_spawn_enemy("default_eye", pos[2])


func spawn_wave(count: int) -> void:
	for pos in _get_random_valid_positions(count):
		_spawn_enemy("default_eye", pos)
