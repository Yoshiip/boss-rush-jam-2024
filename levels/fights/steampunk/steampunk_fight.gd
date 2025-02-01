class_name SteampunkFightRoot
extends FightRoot

@export var hands_speed := 0.2

const DIGIT = preload("res://entities/digit/digit.tscn")

func _add_digits() -> void:
	var points_count := 12
	var radius := 1280
	for i in range(points_count):
		var digit := DIGIT.instantiate()
		var angle := i * TAU / points_count
		
		digit.position = Vector2(cos(angle), sin(angle)) * radius
		digit.digit = i
		add_child(digit)


func _ready() -> void:
	super()
	_add_digits()

func _process(delta: float) -> void:
	$Planet.rotation += spin_speed * delta
	$Hands/Big.rotation += delta * hands_speed
	$Hands/Small.rotation += delta * hands_speed * 1/12
