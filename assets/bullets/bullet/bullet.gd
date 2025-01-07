extends Area2D

var from_enemy := false
var damage := 1

var speed = 10.0

func _ready() -> void:
	if from_enemy:
		# we'il probably make a special bullet for enemy later
		modulate = Color.RED
		
		speed *= 0.6

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * speed


func destroy_bullet():
	#add some sort of explosion effect
	queue_free() 


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Spaceship") && from_enemy:
		body.take_damage(damage)
		queue_free()
