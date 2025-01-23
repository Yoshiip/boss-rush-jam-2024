extends Control

signal ended


# o: stands for "other"

var dialogue: Array[String] = []
var progress := 0

var skip_progress := 0.0


func _ready() -> void:
	dialogue = GameDialogues.TEST_DIALOGUE
	$AnimationPlayer.play("Open")
	
	$Gradient/Content.text = dialogue[progress]


func _close_dialogue() -> void:
	set_process(false)
	$AnimationPlayer.play("Open", -1, -1.0, true)
	await get_tree().create_timer(1.0).timeout
	ended.emit()
	queue_free()


func _next_text() -> void:
	visible_characters = 0
	progress += 1
	if progress >= dialogue.size():
		set_process(false)
		_close_dialogue()
		return
	$Gradient/NextArrow.visible = progress <= dialogue.size() - 2
	var text := dialogue[progress]
	var from_other := text.begins_with("o:")
	$Gradient/Portrait.visible = !from_other
	$Gradient/Name.text = "Other" if from_other else "You"
	$Gradient/Content.text = dialogue[progress].lstrip('o:')
	spawning_text = false

var spawning_text := false


var i := 0.0

var text_timer := 0.05
var visible_characters := 0

func _process(delta: float) -> void:
	if Input.is_action_pressed("fire"):
		skip_progress += delta * 0.5
	else:
		skip_progress -= delta * 0.75
	$HBoxContainer/ProgressBar.value = skip_progress
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
			text_timer = 0.05
			# TODO: maybe add additional delay if it is punctuation
			visible_characters += 1
	
	if progress < dialogue.size() - 1:
		$Gradient/NextArrow.position.y = 84 + cos(i) * 8.0
