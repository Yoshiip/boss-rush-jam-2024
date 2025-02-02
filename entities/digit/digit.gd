extends Area2D

signal digit_on(number: int)

@export var digit := 1

var digits_str: Array[String] = []

const DIGIT_ONE = preload("res://assets/steampunk/digit_one.png")
const DIGIT_FIVE = preload("res://assets/steampunk/digit_five.png")
const DIGIT_TEN = preload("res://assets/steampunk/digit_ten.png")

const DIGIT_VALUES = {
	10: ["ten"],
	9: ["one", "ten"],
	5: ["five"],
	4: ["one", "five"],
	1: ["one"]
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
	_convert_to_roman(digit)
	_create_sprites()


func _convert_to_roman(value: int) -> void:
	digits_str.clear()
	for key in [10, 9, 5, 4, 1]:
		while value >= key:
			digits_str.append_array(DIGIT_VALUES[key])
			value -= key

func _create_sprites() -> void:
	var x := -digits_str.size() * 16.0 + 8
	for digit in digits_str:
		var spr := Sprite2D.new()
		spr.texture = _get_texture(digit)
		spr.position.x = x
		x += 32
		$Sprites.add_child(spr)




var i := 0.0

@onready var core: Core = get_tree().current_scene.core

const LINES_POINT := 10
var last_core_position := Vector2.INF

func _process(delta: float) -> void:
	$ConnectLine.default_color = Color("2ce8f5") if on else Color.WHITE
	if is_instance_valid(core):
		if core.global_position != last_core_position && not broken:
			last_core_position = core.global_position
			$ConnectLine.clear_points()
			var step := Vector2.ZERO
			for i in range(LINES_POINT):
				$ConnectLine.add_point(step - global_position + core.global_position)
				step += (global_position - core.global_position) / LINES_POINT
				print(step)
	$Sprites.scale = $Sprites.scale.lerp(Vector2.ONE, 5.0 * delta)
	$Light.scale = Vector2.ONE * (1.0 + cos(i * 2.0) * 0.2)
	$Light.visible = on
	$Sprites.modulate.a = 0.5 if broken else 1.0
	i += delta

var on := false
var broken := false

func take_damage(_amount: int) -> void:
	if on or broken: return
	$Sprites.scale = Vector2.ONE * 1.5
	if not broken:
		$ConnectLine.clear_points()
		$Destroy.play()
		$Explosion.play()
	broken = true

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group(&"HandClock") and not on and not broken:
		$On.play()
		$Sprites.scale = Vector2.ONE * 1.5
		on = true
		digit_on.emit(digit)
