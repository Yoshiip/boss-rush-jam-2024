extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var core = $Core	
	var planet = $Planet
	

	for default_eye in planet.get_children():
		if default_eye.has_method("on_core_new_phase"):  # Ensure the weapon has the target method
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
