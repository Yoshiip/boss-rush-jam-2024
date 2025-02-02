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
		digit.touched.connect(_on_digit_touched)
		$Digits.add_child(digit)

func _on_core_new_phase(index: int) -> void:
	for pos in _get_random_valid_positions(3):
		_spawn_enemy("", pos)

const DIALOGUE = preload("res://ui/dialogue/dialogue.tscn")

var dialogue: Dialogue
func _on_dialogue_event(id: String) -> void:
	dialogue.set_other("Chief", MAN_TEXTURE)

const MAN_TEXTURE = preload("res://ui/dialogue/portraits/man.jpg")


func _ready() -> void:
	super()
	dialogue = DIALOGUE.instantiate()
	var dial: Array[String]
	dial.assign(GameDialogues.MISSIONS[4])
	dialogue.dialogue = dial
	dialogue.ended.connect(_on_dialogue_ended)
	dialogue.event.connect(_on_dialogue_event)
	
	spaceship.allow_inputs.append("dialogue")
	canvas.get_node("Container").add_child(dialogue)
	_add_digits()

func _on_dialogue_ended() -> void:
	spaceship.allow_inputs.erase("dialogue")

func _process(delta: float) -> void:
	super(delta)
	if spaceship.allow_inputs.is_empty():
		$Hands/Big.rotation += delta * -spin_speed
		$Hands/Small.rotation += delta * -spin_speed * 1/12

func _on_digit_touched(number: int) -> void:
	if number == 12:
		$DigitsFinal.play()
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
