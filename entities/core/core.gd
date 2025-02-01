class_name Core
extends Area2D

signal took_damage
signal new_phase(index: int)
signal dead

const CORE_DEAD_TEXTURE = preload("res://entities/core/core_dead.png")

@export var max_health := 100
@onready var health := max_health
@export var stats : boss_phase_info
@export var contact_damage := 1
@export var max_shoot_timer := 20.0
var shoot_timer := max_shoot_timer

## The number of phases the boss has. The float represents the ratio of speed required to trigger the phase.
@export var phases: Array[float] = [
	0.9,
	0.8,
	0.6,
	0.4,
	0.2,
]

var phase := 0
var starting_wave_args=[3,10,2,0, 0.35,1]
var wave_args_adjust=[1,0,-0.1,0.4,-0.1,0.1]
var wave_args=[0,0,0,0,0,0]
var spin_speed_change =.12
var circle_shoot_amount =15

@onready var camera: BetterCamera = get_tree().current_scene.get_node("Camera")
@onready var root: FightRoot = get_tree().current_scene

var i := 0.0


var BULLET = load("res://assets/bullets/bullet/bullet.tscn")

func _ready() -> void:
	$Sprite.material = $Sprite.material.duplicate()
	root.spin_speed = stats.spin_speed[phase]

func _shoot_circle(number : float) -> void:
	for i in number:
		var bullet: Bullet = BULLET.instantiate()
		if !is_instance_valid(bullet): return
		bullet.position = position
		bullet.from_enemy = true
		bullet.rotation = (PI * 2.0) / number * i
		bullet.bounce_powerup_lvl = true
		bullet.max_bounces = 3
		bullet.special_enemy_projectile = true
		call_deferred("add_sibling", bullet)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet") && !area.from_enemy:
		health -= area.damage
		_shoot_circle(6)
		if  phase < phases.size() && health <= phases[phase] * max_health:
			$BossAnger.play()
			phase+=1
			new_phase.emit(phase)
			root.spin_speed = stats.spin_speed[phase]
			_shoot_circle(stats.circle_bullet_fire[phase])
			var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC).bind_node(self)
			tween.tween_property(self, "position", stats.new_pos[phase], 2.0)
			#root.spawn_spikes(stats.spike_num[phase])
			#var random_angle = randf() * PI * 2
			#var random_distance = randi_range(-10,200)
			#position = Vector2(cos(random_angle), sin(random_angle)) * (root.planet_radius+ random_distance)
			
		if health <= 0:
			$Sprite.texture = CORE_DEAD_TEXTURE
			dead.emit()
			$CollisionShape.set_deferred("disabled", true)
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
	shoot_timer -= delta
	if shoot_timer <= 0.0:
		shoot_timer = max_shoot_timer
		_shoot_circle(6)



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Spaceship"):
		body.take_damage(contact_damage, global_position)
