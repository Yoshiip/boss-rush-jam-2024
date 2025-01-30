extends Node2D

const CREDITS_USER = preload("res://ui/credits/credits_user.tscn")
const SETTINGS_MENU = preload("res://ui/settings/settings_menu.tscn")

const AUTHORS = [
	{
		"name": "Yoshiip",
		"role": "Code",
		"url": "",
	},
	{
		"name": "coinbirdface",
		"role": "Art",
		"url": "",
	},
	{
		"name": "Silvo",
		"role": "Music",
		"url": "",
	},
	{
		"name": "Tentative",
		"role": "Game Design, Code, Art",
		"url": "",
	},
	{
		"name": "moose",
		"role": "Sound Effects",
		"url": "",
	},
	{
		"name": "Avvakira",
		"role": "Art",
		"url": "",
	},
	
]

@onready var menu_section: Control = $Canvas/Container/Menu
@onready var credits_section: Control = $Canvas/Container/Credits

@onready var credits_container: VBoxContainer = $Canvas/Container/Credits/Container

var started := false



func _build_credits() -> void:
	for author in AUTHORS:
		var card := CREDITS_USER.instantiate()
		card.get_node("Name").text = author.name
		card.get_node("Role").text = author.role
		credits_container.add_child(card)
func _ready() -> void:
	_build_credits()
	credits_section.visible = false
	$Crossfade.start_a()

func _process(delta: float) -> void:
	$Camera.offset = $Camera.offset.lerp((get_global_mouse_position() + $Camera.position).normalized() * 25.0, delta)
	$Core.rotation += delta * 0.2
	$Core.scale = $Core.scale.lerp(Vector2.ONE, delta * 15.0)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire") && !started:
		started = true
		$Crossfade.to_b()
		$Canvas/Container/Start.visible = false
		$Canvas/Container/Menu.visible = true

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/intro/intro.tscn")

func _on_credits_button_pressed() -> void:
	menu_section.visible = false
	credits_section.visible = true
	UiUtils.apply_transition(credits_container)


func _on_settings_button_pressed() -> void:
	$Canvas/Container.add_child(SETTINGS_MENU.instantiate())


func _on_go_back_button_pressed() -> void:
	menu_section.visible = true
	credits_section.visible = false
	UiUtils.apply_transition(menu_section)


func _on_hit_timer_timeout() -> void:
	$Core.scale = Vector2(1.3, 1.3)
	$Canvas/Container/Menu/VBoxContainer/Control/Title/AnimationPlayer.play("Bounce")


func _on_debug_1_pressed() -> void:
	GameManager.save_data.level = 1
	get_tree().change_scene_to_file("res://levels/fights/first/first_fight.tscn")


func _on_debug_2_pressed() -> void:
	GameManager.save_data.level = 2
	get_tree().change_scene_to_file("res://levels/fights/steampunk/steampunk_fight.tscn")



func _on_debug_3_pressed() -> void:
	GameManager.save_data.level = 3
	get_tree().change_scene_to_file("res://levels/fights/void/void_fight.tscn")
