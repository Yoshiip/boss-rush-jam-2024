extends Control

signal event(id: String)
signal ended


# o: stands for "other"

var dialogue: Array[String] = []
var other_name := "Other"
var other_texture: CompressedTexture2D

var progress := 0

var skip_progress := 0.0
const PLAYER_PORTRAIT = preload("res://ui/dialogue/portraits/player.jpg")

func set_other(new_other_name: String, texture: CompressedTexture2D) -> void:
	self.other_name = new_other_name
	other_texture = texture


func _ready() -> void:
	$AnimationPlayer.play("Open")
	
	$Gradient/Content.text = dialogue[progress]


func _close_dialogue() -> void:
	set_process(false)
	$AnimationPlayer.play("Open", -1, -1.0, true)
	await get_tree().create_timer(1.0).timeout
	ended.emit()
	queue_free()


var locked := false

func _next_text() -> void:
	visible_characters = 0
	progress += 1
	if progress >= dialogue.size():
		set_process(false)
		_close_dialogue()
		return
	
	$DialogueNext.play()
	$Gradient/NextArrow.visible = progress <= dialogue.size() - 2
	var text := dialogue[progress]
	
	var from_other := text.begins_with("o:")
	if text.begins_with("i:"):
		locked = true
		$AnimationPlayer.play("Open", -1, -1.0, true)
		
		await get_tree().create_timer(float(text.split(':')[1])).timeout
		$AnimationPlayer.play("Open")
		locked = false
		_next_text()
		return
	if text.begins_with("#"):
		event.emit(text.lstrip('#'))
		_next_text()
		return
	$Gradient/Portrait.texture = other_texture if from_other else PLAYER_PORTRAIT
	
	$Gradient/Name.text = other_name if from_other else "You"
	$Gradient/Content.text = dialogue[progress].lstrip('o:')
	spawning_text = false

var spawning_text := false


var i := 0.0

var text_timer := 0.05
var visible_characters := 0

func _process(delta: float) -> void:
	if locked: return
	if Input.is_action_pressed("fire"):
		skip_progress += delta * 0.5
	else:
		skip_progress -= delta * 0.75
	$Skip/ProgressBar.value = skip_progress
	if skip_progress >= 1.0:
		_close_dialogue()
	i += delta
	
	if Input.is_action_just_pressed("fire"):
		if spawning_text:
			visible_characters = $Gradient/Content.visible_characters
			spawning_text = false
		else:
			_next_text()
	
	
	
	$Gradient/Content.visible_characters = visible_characters
	if visible_characters >= $Gradient/Content.text.length():
		spawning_text = false
	else:
		text_timer -= delta
		if text_timer <= 0.0:
			text_timer = 0.03
			# TODO: maybe add additional delay if it is punctuation
			visible_characters += 1
	
	if progress < dialogue.size() - 1:
		$Gradient/NextArrow.position.y = 84 + cos(i) * 8.0
