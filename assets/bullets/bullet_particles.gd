extends CPUParticles2D

var from_enemy := false

func _ready() -> void:
	emitting = true
	if from_enemy:
		modulate = Color("#963160")
	else:
		modulate = Color("#abdd64")

func _on_finished() -> void:
	queue_free()
