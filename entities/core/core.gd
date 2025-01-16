class_name Core
extends Area2D

signal took_damage

const CORE_DEAD_TEXTURE = preload("res://entities/core/core_dead.png")

@export var max_health := 120
@onready var health := max_health
var last_health_threshold = max_health
var starting_wave_args=[3,10,2,0, 0.35,1]
var wave_args_adjust=[1,0,-0.1,0.4,-0.1,0.1]
var wave_args=[0,0,0,0,0,0]
var spin_speed_change =.12
var circle_shoot_amount =15

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
		if health <= last_health_threshold-20:
			last_health_threshold-=20
			_adjust_wave()
			root.spawn_wave(wave_args[0],wave_args[1],wave_args[2],wave_args[3],wave_args[4],wave_args[5])
			root.spin_speed += spin_speed_change
			_shoot_circle(circle_shoot_amount)
		
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

func _adjust_wave() -> void:
	spin_speed_change =.12
	circle_shoot_amount =15
	if last_health_threshold==100:
		circle_shoot_amount+=10
		#default [5,10,1.4,0.2, 0.35,1]
		wave_args_adjust=[2,0,-0.1,0.1,0,0]
	elif last_health_threshold==80:
		circle_shoot_amount+=10
		wave_args_adjust=[1,0,-0.1,0.2,0,0]
	elif last_health_threshold== 60:
		wave_args_adjust=[1,0,-1,0.3,-0.2,0.2]
		circle_shoot_amount+=20
		spin_speed_change-=0.48
	else:
		wave_args=[0,0,0,0,0,0]
		
	wave_args = []
	for i in range(starting_wave_args.size()):
		wave_args.append(starting_wave_args[i] + wave_args_adjust[i])
	
	

	
	
	
