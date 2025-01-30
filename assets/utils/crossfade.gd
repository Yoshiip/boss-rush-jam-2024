class_name Crossfade
extends Node2D

@export var a_stream: AudioStream
@export var b_stream: AudioStream
@export_range(-80.0, 24.0, 0.01) var db := -4.0

var a_player: AudioStreamPlayer
var b_player: AudioStreamPlayer

func _ready() -> void:
	a_player = AudioStreamPlayer.new()
	a_player.bus = &"Music"
	a_player.stream = a_stream
	a_player.autoplay = true
	a_player.volume_db = -80
	add_child(a_player)
	
	b_player = AudioStreamPlayer.new()
	b_player.bus = &"Music"
	b_player.stream = b_stream
	b_player.autoplay = true
	b_player.volume_db = -80
	add_child(b_player)

var last_tween: Tween

func start_a() -> void:
	a_player.play()
	b_player.play()
	a_player.volume_db = db
	b_player.volume_db = -80

func stop_both() -> void:
	if last_tween != null:
		last_tween.stop()
	var tween := _default_tween()
	tween.tween_property(a_player, "volume_db", -80, 5.0)
	tween.tween_property(b_player, "volume_db", -80, 5.0)
	last_tween = tween

func to_a() -> void:
	if last_tween != null:
		last_tween.stop()
	var tween := _default_tween()
	tween.tween_property(a_player, "volume_db", db, 0.5)
	tween.tween_property(b_player, "volume_db", -80, 5.0)
	last_tween = tween
	
func to_b() -> void:
	if last_tween != null:
		last_tween.stop()
	var tween := _default_tween()
	tween.tween_property(a_player, "volume_db", -80, 5.0)
	tween.tween_property(b_player, "volume_db", db, 0.5)
	last_tween = tween
	
func _default_tween() -> Tween:
	return get_tree().create_tween().set_parallel().bind_node(self)
