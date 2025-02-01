class_name FightBossRoot
extends FightRoot


const DEFAULT_EYE = preload("res://entities/eyes/default/default_eye.tscn")
const BOMBER = preload("res://entities/bomber/bomber.tscn")
const SPIKE_BALL = preload("res://entities/Damaging Parts/spike_ball.tscn")
const LASER_EYE = preload("res://entities/eyes/laser_eye/laser_eye.tscn")


func _ready() -> void:
	super()
	
	
	spawn_spikes(3)
	spawn_wave(5)
	spawn_enemy("laser_eye", _get_random_valid_positions(1)[0])
	spawn_enemy("laser_eye", _get_random_valid_positions(1)[0])
	spawn_enemy("laser_eye", _get_random_valid_positions(1)[0])
	spawn_enemy("laser_eye", _get_random_valid_positions(1)[0])
	

func _on_core_new_phase(index: int) -> void:
	super(index)
	match index:
		1:
			spawn_spikes(1)
			spawn_wave(2)
		2:
			var pos := _get_random_valid_positions(2)
			_spawn_enemy(pos[0], "laser_eye")
			_spawn_enemy(pos[1], "bomber")
		3:
			var pos := _get_random_valid_positions(3)
			_spawn_enemy(pos[0], "laser_eye")
			_spawn_enemy(pos[1], "bomber")
			_spawn_enemy(pos[0], "laser_eye")
			spawn_wave(2)
		4:
			spawn_wave(4)
			spawn_spikes(1)
		5:
			spawn_wave(5)
			pass

func _process(delta: float) -> void:
	super(delta)
	planet.rotation += delta * spin_speed


func spawn_enemy(enemy_id: String, pos: Vector2) -> void:
	var enemy: Node2D
	match enemy_id:
		"default_eye":
			enemy = DEFAULT_EYE.instantiate()
		"spike_ball":
			enemy = SPIKE_BALL.instantiate()
		"bomber":
			enemy = BOMBER.instantiate()
		"laser_eye":
			enemy = LASER_EYE.instantiate()
	enemy.global_position = pos
	planet.add_child(enemy)

func _spawn_enemy(pos: Vector2, type: String) -> void:
		var animation := ENEMY_SPAWN_ANIMATION.instantiate()
		animation.position = pos
		animation.done.connect(spawn_enemy.bind("default_eye", pos))
		planet.add_child(animation)

func spawn_wave(count: int) -> void:
	for pos in _get_random_valid_positions(count):
		_spawn_enemy(pos, "default_eye")




func spawn_spikes(num : float) -> void:
	for pos in _get_random_valid_positions(num):
		var spike = SPIKE_BALL.instantiate()
		spike.position = pos
		planet.add_child(spike)
