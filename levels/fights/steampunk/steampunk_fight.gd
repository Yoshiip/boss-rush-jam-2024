class_name SteampunkFightRoot
extends FightRoot

const DIGIT = preload("res://entities/digit/digit.tscn")

func _add_digits() -> void:
	var points_count := 12
	var radius := 1280
	for i in range(points_count):
		var digit := DIGIT.instantiate()
		var angle := i * TAU / points_count - PI/2
		
		digit.position = Vector2(cos(angle), sin(angle)) * radius
		digit.digit = i+1
		digit.digit_on.connect(_on_digit_on)
		$Digits.add_child(digit)

func _on_core_new_phase(index: int) -> void:
	pass

func _ready() -> void:
	super()
	_add_digits()

func _process(delta: float) -> void:
	super(delta)
	$Hands/Big.rotation += delta * -spin_speed
	$Hands/Small.rotation += delta * -spin_speed * 1/12

func _on_digit_on(number: int) -> void:
	if number == 12:
		var no_on := 0
		for digit in $Digits.get_children():
			if digit.on:
				no_on += 1
			digit.on = false
			digit.broken = false
		
		if no_on < 4:
			core.take_damage(10)
		elif no_on < 8:
			core.heal(no_on * 2)
		else:
			core.heal(no_on * 4)
	for pos in _get_random_valid_positions(3):
		_spawn_enemy("", pos)
