class_name Core
extends Area2D

signal took_damage
signal dead

const CORE_DEAD_TEXTURE = preload("res://entities/core/core_dead.png")

@export var max_health := 100
@onready var health := max_health
@export var stats : boss_phase_info
var boss_phase_num :=0
var last_health_threshold = max_health
var starting_wave_args=[3,10,2,0, 0.35,1]
var wave_args_adjust=[1,0,-0.1,0.4,-0.1,0.1]
var wave_args=[0,0,0,0,0,0]
var spin_speed_change =.12
var circle_shoot_amount =15
signal new_phase

@onready var camera: BetterCamera = get_tree().current_scene.get_node("Camera")

var i := 0.0

@onready var root: FightRoot = get_tree().current_scene

var BULLET = load("res://assets/bullets/bullet/bullet.tscn")

func _ready() -> void:
	$Sprite.material = $Sprite.material.duplicate()
	# initials spawns
	root.spawn_wave(stats.eye_num[boss_phase_num],stats.hp[boss_phase_num],stats.fire_rate[boss_phase_num],stats.spc_chance[boss_phase_num],stats.accur[boss_phase_num],stats.bullet_speed[boss_phase_num])
	root.spawn_spikes(stats.spike_num[boss_phase_num])
	root.spin_speed = stats.spin_speed[boss_phase_num]

func _shoot_circle(number : float) -> void:
	for i in number:
		var bullet: Bullet = BULLET.instantiate()
		if !is_instance_valid(bullet): return
		bullet.position = position
		bullet.from_enemy = true
		bullet.rotation = (PI * 2.0) / number * i
		bullet.bounce_powerup = true
		bullet.bounces_count = -1
		bullet.special_enemy_projectile = true
		call_deferred("add_sibling", bullet)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet") && !area.from_enemy:
		health -= area.damage
		if health <= last_health_threshold -20 && boss_phase_num < 5:
			$BossAnger.play()
			last_health_threshold-=20
			boss_phase_num+=1
			#root.spawn_wave(stats.eye_num[boss_phase_num],stats.hp[boss_phase_num],stats.fire_rate[boss_phase_num],stats.spc_chance[boss_phase_num],stats.accur[boss_phase_num],stats.bullet_speed[boss_phase_num])
			emit_signal("new_phase",boss_phase_num,stats.hp[boss_phase_num],stats.fire_rate[boss_phase_num],stats.spc_chance[boss_phase_num],stats.accur[boss_phase_num],stats.bullet_speed[boss_phase_num])
			root.spin_speed = stats.spin_speed[boss_phase_num]
			_shoot_circle(stats.circle_bullet_fire[boss_phase_num])
			position = stats.new_pos[boss_phase_num]
			#root.spawn_spikes(stats.spike_num[boss_phase_num])
			#var random_angle = randf() * PI * 2
			#var random_distance = randi_range(-10,200)
			#position = Vector2(cos(random_angle), sin(random_angle)) * (root.planet_radius+ random_distance)
			
		if health <= 0:
			$Sprite.texture = CORE_DEAD_TEXTURE
			dead.emit()
			$CollisionShape.disabled = true
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


#remove after stability confirmed
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
	
	

	
	
	
