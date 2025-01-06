extends Control


@onready var music_slider: HSlider = $Panel/Container/MusicSlider/Slider
@onready var music_value: Label = $Panel/Container/MusicSlider/Value
@onready var effects_slider: HSlider = $Panel/Container/EffectsSlider/Slider
@onready var effects_value: Label = $Panel/Container/EffectsSlider/Value

func _ready() -> void:
	UiUtils.apply_transition($Panel/Container)
	var music_volume := AudioServer.get_bus_volume_db(1)
	var effects_volume := AudioServer.get_bus_volume_db(2)
	
	update_music_volume(music_volume)
	update_effects_volume(effects_volume)

func update_music_volume(value: float) -> void:
	music_slider.value = value
	music_value.text = str(floor(value * 100), "%")

func update_effects_volume(value: float) -> void:
	effects_slider.value = value
	effects_value.text = str(floor(value * 100), "%")


func _on_close_button_pressed() -> void:
	UiUtils.smooth_queue_free(self)


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if not value_changed: return
	AudioServer.set_bus_volume_db(1, linear_to_db(music_slider.value))
	music_value.text = str(floor(music_slider.value * 100), "%")

func _on_effects_slider_drag_ended(value_changed: bool) -> void:
	if not value_changed: return
	AudioServer.set_bus_volume_db(2, linear_to_db(effects_slider.value))
	effects_value.text = str(floor(effects_slider.value * 100), "%")


func _on_fullscreen_check_box_pressed() -> void:
	get_window().mode = Window.MODE_WINDOWED if get_window().mode == Window.MODE_FULLSCREEN else Window.MODE_FULLSCREEN
