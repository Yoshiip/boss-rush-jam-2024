class_name Core
extends Area2D

signal took_damage

const CORE_DEAD_TEXTURE = preload("res://entities/core/core_dead.png")

@export var max_health := 40
@onready var health := max_health

@onready var camera: BetterCamera = get_tree().current_scene.get_node("Camera")

var i := 0.0

@onready var root: Node2D = $".."

const BULLET = preload("res://assets/bullets/bullet/bullet.tscn")
func _shoot_circle() -> void:
	for i in 8:
		var bullet := BULLET.instantiate()
		bullet.position = position
		bullet.from_enemy = true
		bullet.rotation = (PI * 2.0) / 8.0 * i
		add_sibling(bullet)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet") && !area.from_enemy:
		health -= area.damage
		if health == floor(max_health * 0.75):
			root.spawn_wave()
			root.spin_speed += 0.15
			_shoot_circle()
		elif health == floor(max_health * 0.5):
			root.spawn_wave()
			root.spin_speed += 0.15
			_shoot_circle()
		elif health == floor(max_health * 0.25):
			root.spawn_wave()
			root.spin_speed += 0.15
			_shoot_circle()
		if health <= 0:
			$Sprite.texture = CORE_DEAD_TEXTURE
			$CollisionShape.disabled = true
			get_tree().change_scene_to_file("res://levels/victory/victory.tscn")
		took_damage.emit()
		camera.add_trauma(1)
		area.destroy_bullet()



func _process(delta: float) -> void:
	$Sprite.scale = Vector2.ONE * (0.9 + cos(i) * 0.1)
	i += delta
	
