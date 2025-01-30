extends Area2D

@export var digit := 1

var digits_str: Array[String] = []

const DIGIT_ONE = preload("res://assets/steampunk/digit_one.png")
const DIGIT_FIVE = preload("res://assets/steampunk/digit_five.png")
const DIGIT_TEN = preload("res://assets/steampunk/digit_ten.png")

const DIGIT_VALUES = {
	10: "ten",
	5: "five",
	1: "one"
}
func _get_texture(digit_str: String) -> CompressedTexture2D:
	match digit_str:
		"one":
			return DIGIT_ONE
		"five":
			return DIGIT_FIVE
		_:
			return DIGIT_TEN

func _ready() -> void:
	var remaining = digit
	for value in [10, 5, 1]:
		while remaining >= value:
			digits_str.append(DIGIT_VALUES[value])
			remaining -= value
	var x := -digits_str.size() * 32.0
	for digit in digits_str:
		var spr := Sprite2D.new()
		spr.texture = _get_texture(digit)
		spr.position.x = x
		x += 32
		$Sprites.add_child(spr)
