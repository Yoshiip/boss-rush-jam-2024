class_name TerrainFightRoot
extends FightRoot


func _on_core_new_phase(index: int) -> void:
	match index:
		1:
			for pos in _get_random_valid_positions(3):
				_spawn_enemy("spike_ball", pos)
		2:
			for pos in _get_random_valid_positions(3):
				_spawn_enemy("spike_ball", pos)
		3:
			for pos in _get_random_valid_positions(5):
				_spawn_enemy("spike_ball", pos)
		4:
			pass
		5:
			
			pass

func _process(delta: float) -> void:
	planet.rotation += delta * spin_speed

	
func spawn_wave(count: int) -> void:
	for pos in _get_random_valid_positions(count):
		_spawn_enemy("default_eye", pos)
