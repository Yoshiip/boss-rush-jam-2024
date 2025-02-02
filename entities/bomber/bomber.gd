class_name Bomber
extends CharacterBodyEnemy

@export var speed := 250.0

@onready var timer := 6.0 + randf()
func _ready() -> void:
	super()
	player = get_tree().get_first_node_in_group("Spaceship")
	var tween := get_tree().create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).bind_node(self)
	$Circle.modulate.a = 0.0
	tween.tween_property($Circle, "scale", Vector2.ONE, timer)
	tween.tween_property($Circle, "modulate:a", 0.5, timer)



const EXPLOSION = preload("res://entities/explosion/explosion.tscn")
func _physics_process(delta: float) -> void:
	if is_instance_valid(player):
		look_at(player.global_position)
		velocity = velocity.lerp((player.position - position).normalized() * speed, 5.0 * delta)
		move_and_slide()

func _process(delta: float) -> void:
	timer -= delta
	$Warning.modulate.a = lerp(0.5, 1.0, cos(timer * 10.0))
	if timer <= 0.0:
		var explosion := EXPLOSION.instantiate()
		explosion.global_position = global_position
		add_sibling(explosion)
		queue_free()
