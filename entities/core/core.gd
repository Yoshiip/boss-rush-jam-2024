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

func _ready() -> void:
	$Sprite.material = $Sprite.material.duplicate()

func _shoot_circle(number : float) -> void:
	for i in number:
		var bullet := BULLET.instantiate()
		bullet.position = position
		bullet.from_enemy = true
		bullet.rotation = (PI * 2.0) / number * i
		call_deferred("add_sibling", bullet)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet") && !area.from_enemy:
		health -= area.damage
		if health == floor(max_health * 0.90):
			root.spawn_wave(5,10,1.4,0.2, 0.35,1)
			root.spin_speed += 0.12
			_shoot_circle(25)
		elif health == floor(max_health * 0.75):
			root.spawn_wave(6,10,1.2,0.4,0.35,1)
			root.spin_speed += 0.12
			_shoot_circle(35)
		elif health == floor(max_health * 0.50):
			root.spawn_wave(5,10,1,0.6,0.35,1)
			root.spin_speed -= 0.4
			_shoot_circle(45)
		elif health == floor(max_health * 0.25):
			root.spawn_wave(4,10,1.2,0.9,0.35,1)
			root.spin_speed += 0.5
			_shoot_circle(55)
		if health <= 0:
			$Sprite.texture = CORE_DEAD_TEXTURE
			$CollisionShape.disabled = true
			get_tree().change_scene_to_file("res://levels/victory/victory.tscn")
		else:
			$Sprite.material.set_shader_parameter("whitening", 1.0)
			var tween := get_tree().create_tween()
			tween.tween_property($Sprite.material, "shader_parameter/whitening", 0.0, 0.2)
		took_damage.emit()
		camera.add_trauma(3)
		area.destroy_bullet()



func _process(delta: float) -> void:
	$Sprite.scale = Vector2.ONE * (0.9 + cos(i) * 0.1)
	i += delta
	
