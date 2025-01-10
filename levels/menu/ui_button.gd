extends Button

var hover_sound: AudioStreamPlayer
var click_sound: AudioStreamPlayer

func _ready() -> void:
	
	hover_sound = AudioStreamPlayer.new()
	hover_sound.stream = GameManager.UI_SOUNDS.hover
	hover_sound.volume_db = -12
	add_child(hover_sound)
	
	click_sound = AudioStreamPlayer.new()
	click_sound.stream = GameManager.UI_SOUNDS.click
	hover_sound.volume_db = -3
	add_child(click_sound)
	
	mouse_entered.connect(_on_mouse_entered)
	pressed.connect(_on_pressed)
	

func _on_mouse_entered() -> void:
	hover_sound.play()

func _on_pressed() -> void:
	click_sound.play()
