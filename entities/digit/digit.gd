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
	var x := -digits_str.size() * 16.0 + 8
	for digit in digits_str:
		var spr := Sprite2D.new()
		spr.texture = _get_texture(digit)
		spr.position.x = x
		x += 32
		$Sprites.add_child(spr)


var i := 0.0
func _process(delta: float) -> void:
	$Light.scale = Vector2.ONE * cos(i * 2.0) * 0.2
	$Light.visible = on
	i += delta

var on := false

func take_damage() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body.is_in_group(&"HandClock"):
		on = true
