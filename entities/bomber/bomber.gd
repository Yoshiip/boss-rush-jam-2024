class_name Bomber
extends CharacterBody2D

var player: Spaceship
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Spaceship")
	
	var tween := get_tree().create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	$Circle.modulate.a = 0.0
	tween.tween_property($Circle, "scale", Vector2.ONE, timer)
	tween.tween_property($Circle, "modulate:a", 1.0, timer)

const SPEED := 50.0

var timer := 2.0


const EXPLOSION = preload("res://entities/explosion/explosion.tscn")
func _physics_process(delta: float) -> void:
	if is_instance_valid(player):
		velocity = velocity.lerp((player.position - position).normalized() * 50.0, 5.0 * delta)
		move_and_slide()

func _process(delta: float) -> void:
	timer -= delta
	$Warning.modulate.a = lerp(0.5, 1.0, cos(timer * 10.0))
	if timer <= 0.0:
		var explosion := EXPLOSION.instantiate()
		explosion.global_position = global_position
		add_sibling(explosion)
		queue_free()
