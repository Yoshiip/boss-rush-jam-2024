extends Resource
class_name BossInfo

@export var name := "Boss 1"
@export var max_health := 100
@export var sprite: CompressedTexture2D
@export var background: CompressedTexture2D

@export_group("Music")
@export var music: AudioStream
@export var pause_music: AudioStream
@export var music_db := -4.0

@export_group("Stats")
@export var contact_damage := 1
@export var phases: Array[float] = [0.9, 0.8, 0.6, 0.4, 0.2]

@export var eye_num : Array[float] = [2, 2, 2, 2, 2, 2]
@export var fire_rate: Array[float] = [4.0, 4.0, 4.0, 4.0, 4.0, 4.0]
@export var spc_chance: Array[float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
@export var accur: Array[float] = [0.35, 0.35, 0.35, 0.35, 0.35, 0.35]
@export var bullet_speed: Array[float] =[1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
@export var spin_speed: Array[float] = [0.1, -0.15, 0.2, -0.25, -0.3, 0.35]
@export var circle_bullet_fire: Array[float] = [12, 12, 12, 12, 12, 12]
@export var spike_num: Array[float] = [0, 0, 0, 0, 0, 0]
