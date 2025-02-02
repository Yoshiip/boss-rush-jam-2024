class_name Core
extends Area2D

signal health_changed
signal new_phase(index: int)
signal dead

const CORE_DEAD_TEXTURE = preload("res://entities/core/core_dead.png")
var stats: BossInfo
@onready var max_health := stats.max_health
@onready var health := max_health
@onready var shoot_timer := stats.fire_rate[phase]

var positions: Node2D

var phase := 0
var wave_args=[0,0,0,0,0,0]

@onready var camera: BetterCamera = get_tree().current_scene.get_node("Camera")
@onready var root: FightRoot = get_tree().current_scene

var i := 0.0


var BULLET = load("res://assets/bullets/bullet/bullet.tscn")

func _ready() -> void:
	$Sprite.material = $Sprite.material.duplicate()
	$Sprite.texture = stats.sprite
	root.spin_speed = stats.spin_speed[phase]

func _shoot_circle(number : float) -> void:
	var offset_rot := randf() * TAU
	for i in number:
		var bullet: Bullet = BULLET.instantiate()
		if !is_instance_valid(bullet): return
		bullet.position = position
		bullet.from_enemy = true
		bullet.rotation = offset_rot + (PI * 2.0) / number * i
		bullet.bounce_powerup_lvl = true
		bullet.max_bounces = 3
		bullet.special_enemy_projectile = true
		call_deferred("add_sibling", bullet)


func take_damage(amount: int) -> void:
	health -= amount
	_shoot_circle(1 + randi() % 6)
	if  phase < stats.phases.size() && health <= stats.phases[phase] * max_health:
		$BossAnger.play()
		phase+=1
		new_phase.emit(phase)
		root.spin_speed = stats.spin_speed[phase]
		_shoot_circle(stats.circle_bullet_fire[phase])
		var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC).bind_node(self)
		tween.tween_property(self, "position", positions.get_child(phase).global_position, 4.0)
		#root.spawn_spikes(stats.spike_num[phase])
		#var random_angle = randf() * PI * 2
		#var random_distance = randi_range(-10,200)
		#position = Vector2(cos(random_angle), sin(random_angle)) * (root.planet_radius+ random_distance)
		
	if health <= 0:
		$Sprite.texture = CORE_DEAD_TEXTURE
		dead.emit()
		$CollisionShape.set_deferred("disabled", true)
	else:
		get_tree().current_scene.enemy_impact_sfx(global_position)
		$Sprite.material.set_shader_parameter("whitening", 1.0)
		var tween := get_tree().create_tween()
		tween.tween_property($Sprite.material, "shader_parameter/whitening", 0.0, 0.2)
	health_changed.emit()
	camera.add_trauma(3)

func heal(amount: int) -> void:
	health = min(health + amount, max_health)
	health_changed.emit()

func _process(delta: float) -> void:
	$Sprite.scale = Vector2.ONE * (0.9 + cos(i) * 0.1)
	i += delta
	shoot_timer -= delta
	if shoot_timer <= 0.0:
		shoot_timer = stats.fire_rate[phase]
		_shoot_circle(6)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Spaceship"):
		body.take_damage(stats.contact_damage, global_position)
