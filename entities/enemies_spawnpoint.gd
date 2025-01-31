extends Node2D

func _ready() -> void:
	for child in get_children():
		child.add_to_group(&"EnemySpawnpoint")
