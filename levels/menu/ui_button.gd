extends Button

var hover_sound: AudioStreamPlayer
var click_sound: AudioStreamPlayer

func _ready() -> void:
	
	hover_sound = AudioStreamPlayer.new()
	hover_sound.stream = GameManager.UI_SOUNDS.hover
	hover_sound.bus = &"Effects"
	hover_sound.volume_db = -16
	add_child(hover_sound)
	
	click_sound = AudioStreamPlayer.new()
	click_sound.stream = GameManager.UI_SOUNDS.click
	click_sound.bus = &"Effects"
	click_sound.volume_db = -3
	add_child(click_sound)
	
	mouse_entered.connect(_on_mouse_entered)
	pressed.connect(_on_pressed)
	

func _on_mouse_entered() -> void:
	if is_instance_valid(hover_sound):
		print(hover_sound.volume_db)
		hover_sound.pitch_scale = randf_range(0.9, 1.1)
		hover_sound.play()

func _on_pressed() -> void:
	if is_instance_valid(click_sound):
		click_sound.play()
